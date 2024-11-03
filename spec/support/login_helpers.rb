module LoginHelpers
  def login(user)
    post session_path, params: { email: user.email, password: user.password }
  end
end
