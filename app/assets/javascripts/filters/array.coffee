angular.module('medSupplies.filters')

.filter('joinSupplies', [ ->
	(requests, separator=', ') ->
    return if not requests or not request.supply

    supplies = []
    angular.forEach (request) ->
      supplies.push(request.supply.name) if (request.supply)

		return supplies.join(separator) if angular.isArray(supplies)
])