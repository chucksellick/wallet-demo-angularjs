app = angular.module('walletApp',[ 'LocalStorageModule' ]);

app.controller('walletController', ['$scope', 'localStorageService', ($scope, localStorageService)->
  # Get items from localStorage
  items = localStorageService.get('walletItems')
  console.log items
  $scope.items = items ? []

  # Data persistence
  $scope.persist = ()->
    localStorageService.set('walletItems', $scope.items)
    console.log $scope.items

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
    $scope.persist()

  # Clear out wallet items
  $scope.resetItems = ()->
    $scope.items = []
    $scope.persist()

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
