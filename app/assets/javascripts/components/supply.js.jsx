this.Supply = React.createClass({
    getInitialState: function() {
        return { orderable: this.props.supply.orderable }
    },
    btnIcon: function() {
        var base = "glyphicon glyphicon-"
        return base + (this.state.orderable ? "remove" : "ok")
    },
    btnClass: function() {
        var base = "btn btn-"
        return base + (this.state.orderable ? "danger" : "default")
    },
    toggle: function() {
        this.setState({orderable: !this.state.orderable})
        $.ajax("/supplies/" + this.props.supply.id + "/toggle_orderable", {
            method: "PATCH"
        })
    },
    render: function() {
        return (
            <tr className={this.state.orderable ? "" : "danger"}>
                <td>{this.props.supply.name}</td>
                <td>{this.props.supply.shortcode}</td>
                <td>
                    <a className={this.btnClass()} onClick={this.toggle}>
                        <i className={this.btnIcon()}/>
                    </a>
                </td>
            </tr>
        )
    }
})
