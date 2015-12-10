angular.module("medlink", []).

filter("fallbackFilter", ["$filter", function($filter) {
    return function(arr, searchString) {
        var base = $filter("filter")(arr, searchString)
        if (!base) { return }

        var active = base.filter(function(user) { return user.active })
        if (active.length > 0) {
            return active
        } else {
            return base
        }
    }
}]).

controller("countryRosterController", ["$scope", "$http", function($scope, $http) {
    $scope.filter = ""

    $scope.toggleSort = function(field) {
        if ($scope.sort === field) {
            $scope.reverse = !$scope.reverse
        } else {
            $scope.sort    = field
            $scope.reverse = false
        }
    }

    $scope.toggleSort("last_name")

    $http.get("/api/v1/users").success(function(data) {
        $scope.users = data.users
    })
}])
