from fabric.api import env, local, run

env.roledefs["staging"] = ["compras@nobesistemas.com.br"]

env.repository = "git@github.com:nohupbrasil/compras.git"
env.path = "$HOME/compras"
env.shared_path = "$HOME/shared"
env.symlinks = ["config/database.yml", "config/newrelic.yml", "config/initializers/raven.rb", "config/initializers/mailgun.rb"]

" deploy "
def setup():
    _clone_repository()
    _bundle_gems()
    _make_symlinks()
    _create_database()
    _migrate_database()
    _compile_assets()
    unicorn_start()

def deploy():
    _update_code()
    _bundle_gems()
    _make_symlinks()
    _migrate_database()
    _compile_assets()
    unicorn_reload()

" unicorn "
def unicorn_start():
    run("cd %(path)s && bundle exec unicorn -c config/unicorn.rb -E staging -D" % env)

def unicorn_stop():
    run("kill $(cat %(path)s/tmp/pids/unicorn.pid)" % env)

def unicorn_reload():
    run("kill -s USR2 $(cat %(path)s/tmp/pids/unicorn.pid)" % env)

" application "
def _clone_repository():
    run("rm -rf %(path)s" % env)
    run("git clone %(repository)s %(path)s" % env)

def _bundle_gems():
    run("cd %(path)s && bundle install --deployment --without development:test" % env)

def _make_symlinks():
    for symlink in env.symlinks:
        run("ln -sf %s/%s %s/%s" % (env.shared_path, symlink, env.path, symlink))

def _create_database():
    run("cd %(path)s && bundle exec rake db:create RAILS_ENV=staging" % env)

def _update_code():
    run("cd %(path)s && git fetch origin && git reset --hard origin/master" % env)

def _compile_assets():
    run("cd %(path)s && bundle exec rake assets:precompile RAILS_ENV=staging" % env)

def _migrate_database():
    run("cd %(path)s && bundle exec rake db:migrate RAILS_ENV=staging" % env)
