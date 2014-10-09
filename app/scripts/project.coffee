app = angular.module('walletApp',[ 'LocalStorageModule' ]);

app.controller('walletController', ['$scope', 'localStorageService', ($scope, localStorageService)->
  # Get items from localStorage
  items = localStorageService.get('walletItems')
  $scope.items = items ? []

  # Data persistence
  $scope.persist = ()->
    localStorageService.set('walletItems', $scope.items)

  # Sum the wallet total using underscore reduce
  $scope.getTotal = ()->
    _.reduce($scope.items, (memo, item)->
      memo + item.amount
    , 0);

  # Add a new wallet item
  $scope.addItem = (walletForm, amount)->
    console.log walletForm
    if walletForm.$invalid
      return
    $scope.items.push(
      date: new Date()
      amount: amount
    )
    $scope.persist()

  # Add an amount
  $scope.addAmount = (walletForm, amount)->
    $scope.addItem(walletForm, amount)

  # Remove an amount
  $scope.removeAmount = (walletForm, amount)->
    $scope.addItem(walletForm, -amount)

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

app.controller('sourceController', ['$scope', '$http', ($scope, $http)->
  # Setup list of sources to view
  sources = [
    "index.jade",
    "partials/menu.jade",
    "partials/wallet.jade",
    "partials/source.jade",
    "scripts/project.coffee",
    "styles/style.styl"
  ]
  $scope.sources = []
  async.each(sources,(item,cb)->
    $http({method: 'GET', url: '/'+item}).success((data, status, headers, config)->
        $scope.sources.push(
          filename: item,
          source: data
        )
      ).error((data, status, headers, config)->
        $scope.sources.push(
          filename: item,
          source: "ERROR READING FILE"
        )
      )
  )
])
