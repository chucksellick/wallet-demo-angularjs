app = angular.module('walletApp',[]);

app.controller('walletController', ['$scope', ($scope)->
  $scope.items = [
      { date: new Date(2014,9,9,10,30,0), amount: 10.50 },
      { date: new Date(2014,9,8,11,30,0), amount: -6.23 }
    ]
  # Sum the wallet total using underscore reduce
  $scope.getTotal = ()-> _.reduce($scope.items, (memo, item)->
    memo + item.amount
  , 0);
  # Add a new wallet item
  $scope.addItem = (amount)->
    $scope.items.push(
      date: new Date()
      amount: amount
    )
  # Clear out wallet items
  $scope.resetItems = ()->
    $scope.items = []
  # Catch reset event from menu
  $scope.$on('resetWallet', (e, args)->
    $scope.resetItems()
  )
])

app.controller('menuController', ['$scope', ($scope)->
  # Send reset event to wallet
  $scope.reset = ()->
    $scope.$emit('resetWallet', {})
])
