window.RosterFilter = ({ onChange }) => {
    return <div className="input-group">
        <input
            placeholder="Filter results"
            className="form-control"
            onChange={onChange}/>
        <span className="input-group-addon">
            <i className="glyphicon glyphicon-search"/>
        </span>
    </div>
}
window.RosterFilter.propTypes = {
    onChange: React.PropTypes.func.isRequired
}
