app = angular.module('walletApp',[]);

app.controller('walletController', ['$scope', ($scope)->
  $scope.items = [
      { date: new Date(2014,9,9,10,30,0), amount: 10.50 },
      { date: new Date(2014,9,8,11,30,0), amount: -6.23 }
    ]
  $scope.getTotal = ()-> _.reduce($scope.items, (memo, item)->
    memo + item.amount
  , 0);
  $scope.resetItems = ()->
    $scope.items = []
  $scope.$on('resetWallet', (e, args)->
    $scope.resetItems()
  )
])

app.controller('menuController', ['$scope', ($scope)->
  $scope.reset = ()->
    $scope.$emit('resetWallet', {})
])
