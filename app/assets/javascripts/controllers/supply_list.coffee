angular.module('medSupplies.controllers')

.controller('SupplyListCtrl', [
  '$scope',
  'Supply',

  ($scope, Supply) ->
    console.log "OH MY GOD WORK"
    ###
    order = new Order(
      email: 'wat@wat.com'
      requests_attributes: [
        {supply_id: 1, wow: 2},
        {supply_id: 1},
        {supply_id: 2}
      ]
    )

    order.create().then (result) ->
      console.log result

    ###
    $scope.supplies = Supply.query()

])
