angular.module('medSupplies.filters')

.filter('joinSupplies', [ ->
	(requests, separator=', ') ->
    return if not requests.length

    supplies = []
    angular.forEach requests, (request) ->
      supplies.push(request.supply.name) if (request.supply)

    if angular.isArray(supplies)
      return supplies.join(separator)
])