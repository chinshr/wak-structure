var app = wakanda.createServer();

// configuration
app.configure(function () {
  
  app.configure('development', function () {
    // development setup
  });

  app.configure('test', function () {
    // test setup
  });

  app.configure('production', function () {
    // production setup
  });
  
});