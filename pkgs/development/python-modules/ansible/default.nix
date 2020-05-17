{ lib
, fetchFromGitHub
, buildPythonPackage
, pycrypto
, paramiko
, jinja2
, pyyaml
, httplib2
, six
, netaddr
, dnspython
, jmespath
, dopy
, ncclient
, windowsSupport ? false
, pywinrm
}:

buildPythonPackage rec {
  pname = "ansible";
  version = "2.9.9";

  src = fetchFromGitHub {
    owner = "ansible";
    repo = "ansible";
    rev = "v${version}";
    sha256 = "06a9iq7w2cm0hsxaw5irsja8w44gffiw09ly27jxklpa8gv57rml";
  };

  prePatch = ''
    # ansible-connection is wrapped, so make sure it's not passed
    # through the python interpreter.
    sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py
  '';

  postInstall = ''
    for m in docs/man/man1/*; do
      install -vD $m -t $out/share/man/man1
    done
  '';

  propagatedBuildInputs = [
    pycrypto paramiko jinja2 pyyaml httplib2
    six netaddr dnspython jmespath dopy ncclient
  ] ++ lib.optional windowsSupport pywinrm;

  # dificult to test
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.ansible.com";
    description = "Radically simple IT automation";
    license = [ licenses.gpl3 ] ;
    maintainers = with maintainers; [ joamaki costrouc ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
