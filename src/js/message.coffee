
momentum = angular.module "Momentum.controllers", []

momentum.controller "MessagesController", ['$scope', '$http', ($scope, $http) ->
  # We'll use $resource later.
  $http.get("/api/messages/")
  .success (response) ->
    $scope.data.messages = response
  .error (e) ->
    alert "Something went wrong."
]

momentum.controller "MessageController", ['$scope', '$http', ($scope, $http) ->

  $scope.data =
    id: ""
    message: ""
  $scope.submitGet = ->
    $http.get("/api/messages/#{$scope.data.id}")
    .success (response) ->
      $scope.data.message = response
    .error (e) ->
      alert "Something went wrong. That ID may not exist."


  $scope.submitPost = ->
    $http.post("/api/messages",
      message: $scope.data.message
    ).success (response) ->
      # Fill id box.
      $scope.data.id = response
      alert "Successfully made a message!"


  $scope.submitPut = ->
    $http.put("/api/messages/#{$scope.data.id}",
      message: $scope.data.message
    ).success (response) ->
      alert "Successfully updated a message!"
    .error (response) ->
      alert "Something went wrong."


  $scope.submitDelete = ->
    $http.delete("/api/messages/#{$scope.data.id}")
    .success (response) ->
      $scope.data.id = ""
      $scope.data.message = ""
      alert "Successfully deleted a message!"
    .error (response) ->
      alert "Something went wrong. That ID may not exist."
]
