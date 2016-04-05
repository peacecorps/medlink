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
            editingUser:              null,
            editingFieldName:         null,
            currentlyFetchingCountry: null
        }
    },

    // Fetching user data from server
    componentWillMount: function() {
        this.fetchNextCountry(this.props.countries)
    },
    fetchNextCountry: function(countries) {
        const next = countries.shift()
        if (next) {
            this.setState({ currentlyFetchingCountry: next.name })
            $.ajax(`/api/v1/users?country_id=${next.id}`, {
                success: (data) => {
                    this.loadUsers(data.users)
                    this.fetchNextCountry(countries)
                }
            })
        } else {
            this.setState({ currentlyFetchingCountry: null })
        }
    },
    loadUsers: function(newUsers) {
        const users = Object.assign({}, this.state.users)
        newUsers.forEach(u => users[u.id] = u)
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
        return this.state.sortDirection == 'asc' ? sorted.reverse() : sorted
    },
    results: function() {
        return this.sort(this.filteredUsers())
    },

    // Editing and updating records
    onSelect: function(user, field) {
        this.setState({ editingUser: user, editingFieldName: field })
    },
    getValue: function(user, field) {
        return this.state.users[''+user.id][field]
    },
    setValue: function(user, field, value) {
        const users = Object.assign({}, this.state.users)
        users[''+user.id][field] = value
        this.setState({ users: users })
    },
    stopEditing: function() {
        this.setState({ editingUser: null, editingFieldName: null })
    },
    submitChange: function(user, field, value) {
        const oldValue = this.getValue(user, field)
        if (value === oldValue) {
            this.stopEditing()
            return
        }

        this.setValue(user, field, value)

        const data = {}
        data[field] = value

        $.ajax(`/api/v1/users/${user.id}`, {
            method:  `PATCH`,
            data:    { user: data },
            success: () => {},
            error:   (request, e) => {
                const errors = JSON.parse(request.responseText).errors
                messenger.post({
                    message: errors,
                    type:    "error"
                })
                this.setValue(user, field, oldValue)
            }
        })
        this.stopEditing()
    },

    // Rendering
    render: function() {
        const results   = this.results()
        const displayed = results.slice(0, 50)

        return (<main>
            <div className="row sorttable-controls">
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
                                editingUser  = {this.state.editingUser === user}
                                editingField = {this.state.editingFieldName}
                                onSelect     = {this.onSelect}
                                submitChange = {this.submitChange}
                            />
                        )}
                    </tbody>
                </table>
                <TruncationWarning displayedCount={displayed.length} totalCount={results.length}/>
            </div>
        </main>)
    }
})
