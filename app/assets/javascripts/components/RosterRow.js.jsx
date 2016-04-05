window.RosterRow = React.createClass({
    propTypes: {
        user: React.PropTypes.object.isRequired,
        saveChanges: React.PropTypes.func.isRequired,
    },
    getInitialState: function() {
        return { editing: false, changes: {} }
    },
    handleStart: function() {
        this.setState({ editing: true })
    },
    handleCancel: function(e) {
        e.preventDefault()
        this.setState({ editing: false })
    },
    handleSave: function() {
        this.props.saveChanges(this.props.user, this.state.changes)
        this.setState({ editing: false, changes: {} })
    },
    handleChange: function(name) {
        return (value) => {
            const changes = this.state.changes
            changes[name] = value
            this.setState({ changes: changes })
        }
    },
    render: function() {
        const { user, saveChanges } = this.props

        const makeField = (name, renderer) => {
            let value = this.state.changes[name]
            if (value === undefined) { value = user[name] }

            return <td><RosterField
                value    = {value}
                editing  = {this.state.editing}
                onChange = {this.handleChange(name)}
                renderer = {renderer}
            /></td>
        }

        return <tr>
            {makeField("email")}
            {makeField("first_name")}
            {makeField("last_name")}
            {makeField("role", RoleField)}
            {makeField("pcv_id")}
            {makeField("location")}
            {makeField("phones", PhonesField)}
            <EditButtons
                userId   = {user.id}
                editing  = {this.state.editing}
                onStart  = {this.handleStart}
                onCancel = {this.handleCancel}
                onSave   = {this.handleSave}
            />
        </tr>
    }
})

const EditButtons = ({ userId, editing, onStart, onSave, onCancel }) => {
    if (editing) {
        return <td>
            <a className="btn btn-primary btn-sm"
                onClick={onSave}>Save</a>
            {' '}
            <a className="btn btn-default btn-sm"
                onClick={onCancel}>Cancel</a>
        </td>
    } else {
        return <td>
            <a className="btn btn-default btn-sm"
                onClick={onStart}>Edit</a>
            {' '}
            <a href={`/admin/users/${userId}/edit`}
                className="btn btn-default btn-sm"
                target="_blank">View</a>
        </td>
    }
}
