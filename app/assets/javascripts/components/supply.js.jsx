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
        var o = this.state.orderable
        this.setState({orderable: !o})

        $.ajax(this.props.toggleUrl, {
            method: "PATCH",
            error: () => {
                // TODO: add descriptive notification
                this.setState({orderable: o})
            }
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
