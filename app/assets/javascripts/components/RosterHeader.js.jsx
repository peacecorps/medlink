window.RosterHeader = React.createClass({
    render: function() {
        const { sortColumn, sortDirection, toggleSort } = this.props

        const header = (columnName, caption) => {
            const iconClass = sortDirection === 'asc' ? 'down' : 'up'
            return <th onClick={() => toggleSort(columnName)}>
                {caption}
                {' '}
                {sortColumn == columnName
                    ? <i className={`glyphicon glyphicon-chevron-${iconClass}`}/>
                    : ''}
            </th>
        }

        return <tr>
            {header("email", "Email")}
            {header("first_name", "First Name")}
            {header("last_name", "Last Name")}
            {header("role", "Role")}
            {header("pcv_id", "PCV ID")}
            {header("location", "Location")}
            {header("phones", "Phones")}
            <th></th>
        </tr>
    }
})
