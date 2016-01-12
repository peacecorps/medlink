this.SupplyForm = React.createClass({
    getInitialState: function() {
        return { name: "", shortcode: "" }
    },
    update: function(e) {
        this.setState({[e.target.name]: e.target.value})
    },
    valid: function() {
        return this.state.name && this.state.shortcode
    },
    submit: function() {
        $.ajax("/supplies", {
            method:  "POST",
            data:    { supply: this.state },
            success: this.props.newRecord
            // TODO: handle save error
        })
        this.setState(this.getInitialState())
    },
    render: function() {
        return (
            <tr>
                <td><input name="name" placeholder="Name" className="form-control" value={this.state.name} onChange={this.update}/></td>
                <td><input name="shortcode" placeholder="Shortcode" className="form-control" value={this.state.shortcode} onChange={this.update}/></td>
                <td>
                    <a className="btn btn-default"
                       disabled={!this.valid() }
                       onClick={this.submit} >
                        <i className="glyphicon glyphicon-plus"/> Add
                    </a>
                </td>
            </tr>
        )
    }
})
