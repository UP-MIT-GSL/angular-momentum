
momentum = angular.module "Momentum.controllers", []

momentum.controller "MessagesController", ['$scope', '$http', ($scope, $http) ->
  # We'll use $resource later.
  $http.get("/api/messages/")
  .success (response) ->
    $scope.messages = response
  .error (e) ->
    alert "Something went wrong."
]

momentum.controller "MessageController", ['$scope', '$http', ($scope, $http) ->

  $scope.selectedTab = 'get'
  $scope.select = (tab) ->
    $scope.selectedTab = tab

  $scope.submitGet = ->
    $http.get("/api/messages/#{$scope.id}")
    .success (response) ->
      $scope.message = response
    .error (e) ->
      alert "Something went wrong. That ID may not exist."


  $scope.submitPost = ->
    $http.post("/api/messages",
      message: $scope.message
    ).success (response) ->
      # Fill id box.
      $scope.id = response
      alert "Successfully made a message!"


  $scope.submitPut = ->
    $http.put("/api/messages/#{$scope.id}",
      message: $scope.message
    ).success (response) ->
      alert "Successfully updated a message!"
    .error (response) ->
      alert "Something went wrong."


  $scope.submitDelete = ->
    $http.delete("/api/messages/#{$scope.id}")
    .success (response) ->
      $scope.id = ""
      $scope.message = ""
      alert "Successfully deleted a message!"
    .error (response) ->
      alert "Something went wrong. That ID may not exist."
]
