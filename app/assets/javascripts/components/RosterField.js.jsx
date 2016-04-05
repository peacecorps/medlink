window.RosterField = React.createClass({
    propTypes: {
        user:    React.PropTypes.object.isRequired,
        name:    React.PropTypes.string.isRequired,
        editing: React.PropTypes.bool.isRequired
    },
    getInitialState: function() {
        const { user, name } = this.props
        return { value: user[name] }
    },
    handleClick: function() {
        const { user, name } = this.props
        this.props.onSelect(user, name)
    },
    handleChange: function(e) {
        this.setState({ value: e.target.value })
    },
    handleBlur: function() { this.submit() },
    handleKeyUp: function(e) {
        if (e.key === 'Enter') { this.submit() }
    },
    submit: function() {
        const { user, name } = this.props
        this.props.submitChange(user, name, this.state.value)
    },
    render: function() {
        const { name, user, editing } = this.props

        if (editing) {
            return <td>
                <input
                    className = "form-control"
                    value     = {this.state.value}
                    onChange  = {this.handleChange}
                    onBlur    = {this.handleBlur}
                    onKeyUp   = {this.handleKeyUp}
                />
            </td>
        } else {
            return <td onClick={this.handleClick}>{user[name]}</td>
        }
    }
})
