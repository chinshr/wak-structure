User = require '../../models/user'

routes = (app) ->
  app.namespace '/admin', ->

    # Authentication check
    app.all '/*', (req, res, next) ->
      if not (req.session.currentUser)
        req.flash 'error', 'Please login.'
        res.redirect '/login'
        return
      next()

    app.get '/', (req, res) ->
      res.redirect '/admin/menu/stage'

    app.namespace '/users', ->

      # List all users.
      app.get '/', (req, res) ->
        pie = new Pie {}
        Pie.all (err, pies) ->
          res.render "#{__dirname}/views/pies/all",
            title: 'View All Pies'
            stylesheet: 'admin'
            pie: pie
            pies: pies

      # Create a user.
      app.post '/', (req, res) ->
        attributes =
          name: req.body.name
          type: req.body.type
        user = new User attributes
        pie.save () ->
          req.flash 'info', "User '#{user.name}' was saved."
          res.redirect '/admin/users'

      app.put '/:id', (req, res) ->
        User.getById req.params.id, (err, user) ->
          if _.include(User.states, req.body.state)
            pie[req.body.state] ->
              if socketIO = app.settings.socketIO
                socketIO.sockets.emit "user:changed", user
              # Send plain text reply with default success statusCode of 200.
              res.send "/admin/users/#{req.params.id}"
          else
            res.render 'error',
              status: 403,
              message: "Incorrect User state: #{req.body.state} is not a recognized state."
              title: "Incorrect User state"
              stylesheet: 'admin'

module.exports = routes