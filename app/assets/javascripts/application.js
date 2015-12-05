// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require messenger
//= require messenger-theme-future
//= require chosen.jquery
//= require s3_direct_upload
//= require main

angular.module("medlink", []).

controller("countryRosterController", ["$scope", "$http", function($scope, $http) {
    $scope.filter  = ""

    $scope.toggleSort = function(field) {
        if ($scope.sort === field) {
            $scope.reverse = !$scope.reverse
        } else {
            $scope.sort    = field
            $scope.reverse = false
        }
    }

    $scope.toggleSort("last_name")

    var url = window.location.origin + window.location.pathname
    $http.get(url + ".json").success(function(data) {
        console.log(data)
        $scope.users = data.users
    })
}])
