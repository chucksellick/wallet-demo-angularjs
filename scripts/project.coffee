app = angular.module('walletApp',[]);

app.controller('walletController', ['$scope', ($scope)->
  $scope.wallet = [
    { date: new Date().addDays(-0.5), amount: 10.50 },
    { date: new Date(), amount: -6.23 }
  ]
])
