angular.module('medSupplies.filters')

.filter('count', [ ->
	(string, max='160') ->
    return if not string then 0 else (max - string.length)
])