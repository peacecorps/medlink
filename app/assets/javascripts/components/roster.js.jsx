// TODO: glyphicon-chevron-(up|down) on active column
var SortableHeader = React.createClass({
    titleize: function(str) {
      return str.toLowerCase().replace(/[-_]/, ' ').replace(/(?:^|\s)\S/g, function (m) {
        return m.toUpperCase()
      })
    },

    render: function() {
      return (
          <th className="sortHeader">
              <a onClick={this.props.sort}>{this.titleize(this.props.name)}</a>
          </th>
      )
    }
})

var Pager = React.createClass({
    getInitialState: function() {
        return { page: this.props.page || 1 }
    },
    prev: function() {
        this.goto(this.state.page - 1)
    },
    next: function() {
        this.goto(this.state.page + 1)
    },
    goto: function(n) {
        this.setState({page: n})
        this.props.onChange(n)
    },

    render: function() {
        return (
            <ul>
                <li><a onClick={this.prev}>Prev</a></li>
                <li>{this.state.page}</li>
                <li><a onClick={this.next}>Next</a></li>
            </ul>
        )
    }
})

// Mostly cribbed from _, but with a change to the semantics of `immediate`
function debounce(func, wait) {
  var timeout, args, context, timestamp, result;

  var later = function() {
    var last = new Date()- timestamp;

    if (last < wait && last >= 0) {
      timeout = setTimeout(later, wait - last);
    } else {
      timeout = null;
      result = func.apply(context, args);
      if (!timeout) context = args = null;
    }
  };

  return function(immediate) {
    console.log("Called debounced fn")
    context = this;
    args = arguments;
    timestamp = new Date();
    var callNow = immediate || !timeout;
    if (!timeout && !immediate) timeout = setTimeout(later, wait);
    if (callNow) {
      console.log("Calling now")
      result = func.apply(context, args);
      context = args = null;
    }

    return result;
  };
};

this.Roster = React.createClass({
    getInitialState: function() {
        return {
            filter:        "",
            page:          1,
            sortColumn:    "",
            sortDirection: "",
            users:         []
        }
    },
    componentWillMount: function() { this.runSearch(true) },
    runSearch: function() {
        return $.ajax("/api/v1/users", {
            method: "GET",
            data: {
                sort:   this.state.sortColumn,
                dir:    this.state.sortDirection,
                page:   this.state.page,
                filter: this.state.filter
            },
            success: (data) => { this.setState({users: data.users}) }
            // FIXME: error handler
        })
    },
    debouncedSearch: debounce(function() { this.runSearch }, 500),
    filter: function(e) {
        this.setState({filter: e.target.value, running: true}, () => {
            if (this.xhr) {
                this.xhr.abort()
                this.xhr = null
            }

            this.xhr = this.runSearch () => {
                this.setState({running: false})
            }
        })
    },
    header: function(name) {
        return (<SortableHeader name={name} sort={this.sortOn.bind(this, name)}/>)
    },
    sortOn: function(name) {
        var diff;

        if (this.state.sortColumn == name) {
            var d = this.state.sortDirection
            diff = {sortDirection: (d == "asc" ? "desc" : "asc")}
        } else {
            diff = {sortColumn: name, sortDirection: "asc"}
        }
        this.setState(diff, this.runSearch)
    },
    editUrl: function(user) {
        return `/admin/users/${user.id}/edit`
    },
    telLink: function(number) {
        var href = `tel:${number}`
        return (<a href={href}>{number}</a>)
    },
    changePage: function(n) {
        this.setState({page: n}, this.runSearch)
    },

    render: function() {
        return (
            <div className="roster">
              <div className="row sortable-controls">
                  <div className="col-md-4">
                      <p>FIXME: roster upload</p>
                  </div>
                  <div className="col-md-4">
                      <p>FIXME: new user link</p>
                  </div>
                  <div className="col-md-4">
                      <div className="input-group">
                          <input placeholder="Filter results" className="form-control" onChange={this.filter}/>
                          <span className="input-group-addon">
                              <i className="glyphicon glyphicon-search"/>
                          </span>
                      </div>
                  </div>
              </div>

              <div className="row">
                  <Pager page={this.state.page} onChange={this.changePage}/>
              </div>

              <div className="row">
                  <table className="table table-condensed table-striped table-hover">
                      <thead>
                          <tr>
                              {this.header("email")}
                              {this.header("first_name")}
                              {this.header("last_name")}
                              {this.header("role")}
                              {this.header("location")}
                              <th>Phone(s)</th>
                              <th></th>
                          </tr>
                      </thead>
                      <tbody>
                          {this.state.users.map((user) => {
                               return (
                                   <tr key={user.id} className={user.active ? "" : "danger"}>
                                       <td>{user.email}</td>
                                       <td>{user.first_name}</td>
                                       <td>{user.last_name}</td>
                                       <td>{user.role}</td>
                                       <td>{user.location}</td>
                                       <td>
                                           <ul>
                                               {user.phones.map((phone) => {
                                                    return (<li>{this.telLink(phone)}</li>)
                                                })}
                                           </ul>
                                       </td>
                                       <td>
                                           <a className="btn btn-default btn-sm" href={this.editUrl(user)}>Edit</a>
                                       </td>
                                   </tr>
                               )
                           })}
                      </tbody>
                  </table>
              </div>
          </div>
        )
    }
})
