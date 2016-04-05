const messenger = Messenger()

const RosterFetchStatus = ({ fetching }) => {
    if (!fetching) { return <span/> }
    return <p>Fetching {fetching} ...</p>
}


const TruncationWarning = ({ displayedCount, totalCount }) => {
    if (displayedCount === totalCount) {
        return <span/>
    } else {
        return <p>Showing {displayedCount} of {totalCount} users. Add a filter to see others.</p>
    }
}
TruncationWarning.propTypes = {
    displayedCount: React.PropTypes.number.isRequired,
    totalCount: React.PropTypes.number.isRequired
}


window.Roster = React.createClass({
    getInitialState: function() {
        return {
            users:                    {},
            sortColumn:               'last_name',
            sortDirection:            'asc',
            searchFilter:             '',
            currentlyFetchingCountry: null,
            truncating:               (this.props.countriesToLoad.length > 1)
        }
    },

    // Fetching user data from server
    componentWillMount: function() {
        this.fetchNextCountry(this.props.countriesToLoad.slice())
    },
    fetchNextCountry: function(countries) {
        const next = countries.shift()
        if (next) {
            this.setState({ currentlyFetchingCountry: next.name })
            $.ajax(`/api/v1/countries/${next.id}/users`, {
                success: (data) => {
                    this.loadUsers(next.name, data.users)
                    this.fetchNextCountry(countries)
                }
            })
        } else {
            this.setState({ currentlyFetchingCountry: null })
        }
    },
    loadUsers: function(country, newUsers) {
        const users = Object.assign({}, this.state.users)
        newUsers.forEach(u =>
            users[u.id] = Object.assign({country: country}, u)
        )
        this.setState({ users: users })
    },

    // Filtering and sorting fetched users
    handleFilterChange: function(e) {
        this.setState({ searchFilter: e.target.value })
    },
    filteredUsers: function() {
        const filter = this.state.searchFilter.toLowerCase()
        const hits = []
        Object.keys(this.state.users).forEach(k => {
            const user = this.state.users[k]
            if (JSON.stringify(user).toLowerCase().includes(filter)) {
                hits.push(user)
            }
        })
        return hits
    },
    toggleSort: function(column) {
        const current = this.state.sortColumn
        if (this.state.sortColumn == column && this.state.sortDirection == 'asc') {
            this.setState({ sortDirection: 'desc' })
        } else {
            this.setState({ sortColumn: column, sortDirection: 'asc' })
        }
    },
    sort: function(array) {
        const sortKey = this.state.sortColumn
        const sorted = array.sort((a,b) => {
            return a[sortKey] < b[sortKey] ? -1 : 1
        })
        return this.state.sortDirection == 'desc' ? sorted.reverse() : sorted
    },
    results: function() {
        return this.sort(this.filteredUsers())
    },
    truncatedResults: function() {
        const results = this.results()
        if (this.state.truncating) {
            return [results.slice(0, 50), results.length]
        } else {
            return [results, results.length]
        }
    },

    // Editing and updating records
    replaceUser: function(user) {
        const users = Object.assign({}, this.state.users)
        users[''+user.id] = user
        this.setState({ users: users })
    },
    saveChanges: function(user, changes) {
        if (Object.keys(changes).length === 0) { return }

        this.replaceUser(Object.assign({}, user, changes))

        $.ajax(`/api/v1/users/${user.id}`, {
            method:  `PATCH`,
            data:    { user: changes },
            success: () => {},
            error:   (request, e) => {
                const errors = JSON.parse(request.responseText).errors
                messenger.post({
                    message: errors,
                    type:    "error"
                })
                this.replaceUser(user)
            }
        })
    },

    // Rendering
    render: function() {
        const truncatedResults = this.truncatedResults()
        const displayed        = truncatedResults[0]
        const totalCount       = truncatedResults[1]

        return (<main>
            <div className="row sorttable-controls">
                {this.props.children}
                <div className="col-md-4">
                    <RosterFilter onChange={this.handleFilterChange}/>
                </div>
            </div>
            <div className="row">
                <RosterFetchStatus fetching={this.state.currentlyFetchingCountry}/>
                <table className="table table-condensed table-striped table-hover">
                    <thead>
                        <RosterHeader
                            toggleSort    = {this.toggleSort}
                            sortColumn    = {this.state.sortColumn}
                            sortDirection = {this.state.sortDirection}
                        />
                    </thead>
                    <tbody>
                        {displayed.map(user =>
                            <RosterRow
                                key          = {user.id}
                                user         = {user}
                                saveChanges  = {this.saveChanges}
                            />
                        )}
                    </tbody>
                </table>
                <TruncationWarning displayedCount={displayed.length} totalCount={totalCount}/>
            </div>
        </main>)
    }
})
