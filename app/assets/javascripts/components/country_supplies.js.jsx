// TODO: unify this with the global supply list component
this.CountrySupplies = React.createClass({
    getInitialState: function() {
        return { supplies: this.props.supplies }
    },
    toggleUrl: function(supply) { return "/country/supplies/" + supply.id + "/toggle" },

    render: function() {
        return (
            <table className="table table-striped table-linked table-condensed">
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Short Code</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    {this.state.supplies.map((supply) => {
                         return (<Supply key={supply.id} supply={supply} toggleUrl={this.toggleUrl(supply)}/>)
                    })}
                </tbody>
            </table>
        )
    }
})
