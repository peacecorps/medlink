window.BaseField = ({ value, editing, handleChange }) => {
    if (editing) {
        return <input
            className = "form-control"
            value     = {value}
            onChange  = {(e) => handleChange(e.target.value)}/>
    } else {
        return <span>{value}</span>
    }
}

window.RoleField = ({ value, editing, handleChange }) => {
    const choices = {
        pcv:   "PCV",
        pcmo:  "PCMO",
        admin: "Admin"
    }

    if (editing) {
        return <select
                   className="form-control"
                   onChange={(e) => handleChange(e.target.value)}
               >
            {Object.keys(choices).map(k =>
                <option key={k} value={k}>{choices[k]}</option>
            )}
        </select>
    } else {
        return <span>{choices[value] || value}</span>
    }
}

window.PhonesField = ({ value, editing, handleChange }) => {
    const parse = (str) => str.split("\n")
    const stringify = (arr) => arr.join("\n")

    if (editing) {
        return <textarea
            className = "form-control"
            rows      = {value.count + 1}
            value     = {stringify(value)}
            onChange  = {e => handleChange(parse(e.target.value))}
        />
    } else {
        return <ul>
            {value.map((p,i) =>
                <li key={`${p}:${i}`}><a href={`tel:${p}`}>{p}</a></li>
            )}
        </ul>
    }
}

window.RosterField = React.createClass({
    propTypes: {
        editing:  React.PropTypes.bool.isRequired,
        renderer: React.PropTypes.func
    },
    render: function() {
        const renderer = this.props.renderer || window.BaseField
        const { value, editing } = this.props
        return renderer({
            value:         value,
            editing:       editing,
            handleChange:  this.props.onChange
        })
    }
})
