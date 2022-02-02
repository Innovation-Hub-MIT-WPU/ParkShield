bool checkPasswords(
    {required String password, required String confirmPassword}) {
  if (password == confirmPassword) return true;
  return false;
}
