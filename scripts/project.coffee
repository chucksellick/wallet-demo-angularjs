app = angular.module('walletApp',[]);

app.controller('walletController', ['$scope', ($scope)->
  $scope.wallet = [
    { date: new Date(2014,9,9,10,30,0), amount: 10.50 },
    { date: new Date(2014,9,8,11,30,0), amount: -6.23 }
  ]
])
