var app = angular.module('kryptacme', [
    'ngResource',
    'hateoas',
    'angularMoment'
]);

app.config(function ($httpProvider, $resourceProvider, HateoasInterceptorProvider) {
    $httpProvider.defaults.useXDomain = true;
    $resourceProvider.defaults.stripTrailingSlashes = false;
    HateoasInterceptorProvider.transformAllResponses();
});

app.controller('KryptController', function ($scope, KryptService) {
    $scope.krypt = KryptService;
});

app.service('KryptService', function ($resource, moment) {

    var self = {
        'projects': [],
        'stats': {},
        'expiring_certs': [],
        'expired_certs': [],
        'loadData': function () {
            self.stats.certs = 0;
            self.stats.project = 0;
            self.stats.certs_to_expire = 0;
            self.stats.certs_expired = 0;
            var today = moment(new Date());
            $resource("/projects").query(null, function (items) {
                angular.forEach(items, function (item) {
                    item.resource("certificates").query(null, function (certs) {
                        item['certs'] = certs;
                        angular.forEach(certs, function (cert) {
                            cert_date = moment(cert.expired_at).diff(today, 'days');
                            if (cert_date > 0 && cert_date < 90) {
                                cert['days_to_expire'] = cert_date;
                                self.expiring_certs.push(cert);
                                self.stats.certs_to_expire++;
                            } else if (cert_date < 0) {
                                cert['days_to_expire'] = cert_date;
                                self.expired_certs.push(cert);
                                self.stats.certs_expired++;
                            }
                        });
                        self.stats.certs = self.stats.certs + certs.length;
                    });
                    self.projects.push(item);
                    self.stats.project++;
                });
            });
        }
    };

    self.loadData();

    return self;

});