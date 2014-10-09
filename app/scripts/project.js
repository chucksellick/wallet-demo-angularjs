// Generated by CoffeeScript 1.8.0
(function() {
  var app;

  app = angular.module('walletApp', ['LocalStorageModule']);

  app.controller('walletController', [
    '$scope', 'localStorageService', function($scope, localStorageService) {
      var items;
      items = localStorageService.get('walletItems');
      $scope.items = items != null ? items : [];
      $scope.persist = function() {
        return localStorageService.set('walletItems', $scope.items);
      };
      $scope.getTotal = function() {
        return _.reduce($scope.items, function(memo, item) {
          return memo + item.amount;
        }, 0);
      };
      $scope.addItem = function(walletForm, amount) {
        console.log(walletForm);
        if (walletForm.$invalid) {
          return;
        }
        $scope.items.push({
          date: new Date(),
          amount: amount
        });
        return $scope.persist();
      };
      $scope.addAmount = function(walletForm, amount) {
        return $scope.addItem(walletForm, amount);
      };
      $scope.removeAmount = function(walletForm, amount) {
        return $scope.addItem(walletForm, -amount);
      };
      $scope.resetItems = function() {
        $scope.items = [];
        return $scope.persist();
      };
      return $scope.$on('resetWallet', function(e, args) {
        return $scope.resetItems();
      });
    }
  ]);

  app.controller('menuController', [
    '$scope', function($scope) {
      return $scope.reset = function() {
        return $scope.$emit('resetWallet', {});
      };
    }
  ]);

  app.controller('sourceController', [
    '$scope', '$http', function($scope, $http) {
      var sources;
      sources = ["index.html", "partials/menu.html", "partials/wallet.html", "partials/source.html", "scripts/project.coffee"];
      $scope.sources = [];
      return async.each(sources, function(item, cb) {
        return $http({
          method: 'GET',
          url: '/' + item
        }).success(function(data, status, headers, config) {
          return $scope.sources.push({
            filename: item,
            source: data
          });
        }).error(function(data, status, headers, config) {
          return $scope.sources.push({
            filename: item,
            source: "ERROR READING FILE"
          });
        });
      });
    }
  ]);

}).call(this);
