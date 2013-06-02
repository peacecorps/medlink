angular.module('medSupplies.filters')

.filter('count', [ ->
	(string, max='160') ->
    if not string then string = ''
    return max - string.length
])