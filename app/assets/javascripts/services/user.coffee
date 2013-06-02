angular.module('medSupplies.services')

.factory('CurrentUser', [
  'railsResourceFactory',

  (railsResourceFactory) ->
    return railsResourceFactory(
      url: '/users/current'
      name: 'user'
    )
])