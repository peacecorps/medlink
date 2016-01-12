this.Supplies = React.createClass({
    getInitialState: function() {
        return { supplies: this.props.data }
    },
    newRecord: function(supply) {
        var s = this.state.supplies.slice()
        s.push(supply)
        this.setState({supplies: s})
    },
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
                    {this.state.supplies.map(function(supply){
                         return (<Supply key={supply.id} supply={supply}/>)
                    })}
                    <SupplyForm newRecord={this.newRecord}/>
                </tbody>
            </table>
        )
    }
})
