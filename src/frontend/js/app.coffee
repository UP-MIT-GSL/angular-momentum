
momentum = angular.module("Momentum", [])

momentum.controller "MessagesController", ['$scope', '$http', ($scope, $http) ->
  # We'll use $resource later.
  $http.get("/api/messages/")
  .success (response) ->
    $scope.messages = response
  .error (e) ->
    alert "Something went wrong."
]
