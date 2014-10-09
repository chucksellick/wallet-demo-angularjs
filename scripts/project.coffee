app = angular.module('walletApp',[ 'LocalStorageModule','ngRoute' ]);

app.config(['$routeProvider',
  ($routeProvider)->
    $routeProvider.
      when('/wallet', {
        templateUrl: 'partials/wallet.html',
        controller: 'walletController'
      }).
      when('/source', {
        templateUrl: 'partials/source.html',
        controller: 'sourceController'
      }).
      otherwise({
        redirectTo: '/wallet'
      });
])

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
    if $scope.getTotal()+amount < 0
      walletForm.$setValidity("negativeTotal", false, "trans-value")
    else
      walletForm.$setValidity("negativeTotal", true, "trans-value")

    if walletForm.$invalid
      return
    $scope.items.push(
      date: new Date()
      amount: amount
    )
    $scope.persist()

  # Validation pattern to ensure greater than 0
  $scope.onlyNumbers = /^[1-9][0-9]*$/;

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

app.controller('menuController', ['$scope', '$rootScope', '$location', ($scope, $rootScope, $location)->
  # Send reset event to wallet
  $scope.reset = ()->
    $rootScope.$broadcast('resetWallet', {})

  # Get active class for menu
  $scope.isPath = (path)->
    console.log $location.path()
    ($location.path().substr(0, path.length) == path)
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
  # Load source files asynchronously
  async.each(sources,(item,cb)->
    $http({method: 'GET', url: item}).success((data, status, headers, config)->
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
