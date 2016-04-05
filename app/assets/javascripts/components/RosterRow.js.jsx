window.RosterRow = React.createClass({
    propTypes: {
        user: React.PropTypes.object.isRequired,
        editingUser: React.PropTypes.bool.isRequired,
        editingField: React.PropTypes.string,
        onSelect: React.PropTypes.func.isRequired,
        submitChange: React.PropTypes.func.isRequired
    },
    render: function() {
        const { user, editingUser, editingField, onSelect, submitChange } = this.props

        const makeField = (name) => {
            const editing = editingUser && name === editingField

            return <RosterField
                       user         = {user}
                       name         = {name}
                       editing      = {editing}
                       onSelect     = {onSelect}
                       submitChange = {submitChange}
                   />
        }

        return <tr>
            {makeField("email")}
            {makeField("first_name")}
            {makeField("last_name")}
            <td>{user.role}</td>
            {makeField("location")}
            <td>
                <ul>
                    {user.phones.map((p,i) =>
                        <li key={`${user.id}:${i}:${p}`}><a href={`tel:${p}`}>{p}</a></li>
                    )}
                </ul>
            </td>
            <td>
                <a
                    href={`/admin/users/{user.id}/edit`}
                    className="btn btn-default btn-sm"
                    target="_blank">Edit</a>
            </td>
        </tr>
    }
})
