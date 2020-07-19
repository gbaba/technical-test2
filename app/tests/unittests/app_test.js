let chai = require('chai');
let chaiHttp = require('chai-http');
var should = chai.should();
chai.use(chaiHttp);
let server = require('../..');
//Our parent block
describe('Myapplication', () => {
 describe('/GET myapplication', () => {
     it('it should GET all the myapplication', (done) => {
     chai.request(server)
       .get('/version')
       .end((err, res) => {
             (res).should.have.status(200);
             (res.body).should.be.a('object');
             (res.body.myapplication.length).should.be.eql(1);
             done();
          });
       });
  });
});