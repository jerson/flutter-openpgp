import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openpgp/key_options.dart';
import 'package:openpgp/key_pair.dart';
import 'package:openpgp/openpgp.dart';
import 'package:openpgp/options.dart';

const passphrase = 'test';
const privateKey = '''-----BEGIN PGP PRIVATE KEY BLOCK-----
lQPGBF0Tpe0BCADm+ja4vMKuodkQEhLm/092M/6gt4TaKwzv8QcA53/FrM3g8wab
oksgIN1T+CscKXOY9GeJ530sBZgu9kTsMeQW3Uf76smo2CV1W7kSTMU+XE5ExGET
+LhkKeHpXoLfZNegKuzH1Qo7DGDOByVrnijbZIukonGwvC/MTduxb69ub+YRhWJc
fCjpMhm4WsC4h0Oz3ir5kx6NsN7XGVT5ghR9OEV6jlFmJ1nYYQxMlBGiATN5f2VR
Y/T9QBLOEsLNvK4OqviLVvgPTQZBePoCeL73CxTbqVhcamvFRVicivl8AphDLATn
1HlIjsTtbH5I/STb8UUdL+4ziRzsQukEw++xABEBAAH+BwMCgg+SBD0Y7LHmqHqo
tQNJrhXRgflQyO4rApMl7dCsilQXPKOd2N85hJbg08PaIaD4dXIylaLF/SRVl5Cw
Mbleqjw/ZNQLmJnTm/diQmTJKXLhsiHS5Cd7nV+KIMwwVX96TCczPqw0i5f2c1p4
tplhJcqEMDA1uOhtALKXLTS3MUBIJV9izj+3HZFAngEJcTZnr8Jq7juEWXxdiSfA
xen3gw6PlfNSvQDQa+D+AH1/k0mpgf07xMUrOVCCUNQJpPKqVWqeNYXGVujcHqD2
FG4CK/lwB3jyVqLJyWsGH359Knhhbhdx879wFY6cldVqvHWk2wFYhzda+As8sJZ4
A1Eyd38uwUBatszAR23ngaMQR3Lc3A/4LS6ahC4QbMtBYHM5Wse1EqD+pFnQs+cP
qPLhuRnMPggYqr1DQYTL9b/f90zq2DW4ZKacG2rNdbTRvzmfWRdRzuhe+jg+8fVe
1sa/BXNbi9JnvVunFxViKVtwdLorBklnJ/wxXpPNILX2EEXC5/Rn8DSPQPX/hJqN
ObL8hE5HQWU/6jhudxvRQM87ebfvGoNOO+ws5HsrbWqS8sgPW/G/BYO429B86Y+q
UY6CB1z/UtImogV6D6+nfUk9rcWRxdB0FcQqE0WlMWXB0lKzV1yiQQCZTDBdhqb4
oVsHe7ugm9E2pz/0lAI11zyctLCqApC1wsjTHqyUPhTffm4UPlBBQg1JK+ksqVrb
CyLvIgx9sLaicMFhL/askReu44jzofuGeTxZrsdzfycgHzFhnjMaQN5/nkSQ41m7
r79VPVSLzXG/XTT4Yf1X8kXX6Sbs2TYn8sWs+Dq/xkebRc9oFVnOg3k890j1Eihx
+/3KbwyxnxQEFtcbIOGmt46UKpYI0mI3EFhRUB6nZWA9wcahIctFMdsMoeR+a/N2
EiINAZbYwpI7tFhUZXN0IENsaWVudCBQcmVwYWdvIChMbGF2ZSBkZSBjbGllbnRl
IHV0aWxpemFkYSBlbiB0ZXN0IGF1dG9tYXRpemFkb3MpIDxjbGllbnRAdGVzdC5j
b20+iQFOBBMBCAA4FiEEjO0uILc5+F8M/RB/gdA542JdgXAFAl0Tpe0CGwMFCwkI
BwIGFQoJCAsCBBYCAwECHgECF4AACgkQgdA542JdgXCNRwf/eGLbWMMBA2Hmg+dY
F/UGph9g7GsgKj7CshB5oLCXSXAitu7D2xI6yN4PLCs3tmhuoT4GPhYy6f7Al1ms
rfDdcDe1O4JxQrtnLM8pMkyjME7mbNOsOSxFllmRt1nG1VOBHTVTdLAmK9Tn4EIi
PQk+/x+R2TNdpubuEIMPvQhcjAW/bD4zMCgTB50C5KfydBZosuSk3WS/qNvJX7bQ
DiQ4PmUwobNC1p72QqyyqriJF+7oCPOYmZXnoWhVl+QcfcPQ9OrhEWxZVsZaJ0fe
GgPaF/a413GjWXg0UqR6oeSZUzEq1109ZC1TS2YngYQNN93jWj8DBbisgJZ1QVfX
f0M+4J0DxgRdE6XtAQgA9y91os2/Fx0AG1Fz6lHuFHN2KUQl6/9cJCHu2rQyD9GO
+LsXpJRzDxYcTvvKQS/2w64fuKI3Yw1vEbhN7YEkw6eSceGBt9nR8KaE2dZ/TfBX
OfDGN847t59idzfOrzZEk/6g8yhH+0lH4rvihNMd/lNEFKLLS/YlSV2uM4PrXtMk
6grfCMxm0OoOqgjcW22/W2YvsQ3ZfM93/vqGCDIWpIsbsIA7FjG5Wyx+8hNIJDMx
D+T+QtTLEe08ta7Si+kT7D76mwl44qiNsoka8ABRF9c0IamaxUclZMzNbkERqhVf
SAw6MCuOJMXs7pkuySxYK2c60BWNKDoac6Da1sZGpQARAQAB/gcDAtrcLO888FSk
5gmauOr9eoV47yng0XL5MQNzu94y+pXNqfLSY+kab8oTLzv8pXv3pQF6HR9mYipM
vwhH4G0wZ6uta70KWdIzTwHMQTRZKqa+rSRqVSk5WkGrzC07lyEuX8CdeWDpvz08
FGIj2mbGmoPyufOuVOqsMdWSUKtR2HOlpqxGWwe6hj8kouvdC8g8ZoQSII7Fd/6C
IiOwUrxiMeyF6g2aMUsp/r3O4hKKlNguRKsziu1kYcoIkVkdsDptD9q+a7ZKSk/+
xjpq1yaQpqn2hrvhPgar2tWvyRcNnnbyb3L/nbgCCKvwTo0sdidjwFCz/3KxzX6L
jflB59fwu61Ms82Xc5oAWgRTISed6jxNCHAC7c48BkV5p9MLrhCgrqKYcSXyEcZE
s6W74vGfftK0150MnMRyKpjwrxerBuCK2LUbucm3lgyNJDkAEt7Nq8mv7tqiH4Yp
Iy7F70hGyfuQvC1a8PIhROoB17OKXNyqUnWhgiAivUkMS8IcKRPRfYGROwY7+zax
dNeH7PhgQN4s+mWXuqj70CJzs5M9u8z65YyPBQkQnNnpoXg72oLxUw3n6ecFiHN2
S0lrtQ1qrYIDKyodCwnTRhF0bx8c2NRQoCSKqmYPoCVJKbW6VivyoF88B50eXIxF
J1t02lkQvHs8xtVSe7Xz4WyxF38DD9utt4iyUk3IRu9+XP6N/fk6Yv8iIKuINQbr
2a3B6DjUJrqVWL62di9suxDII01+klvGYSM/8AFJxghM8YkJf34d8SbeLsc3fh6p
sKW4WJQ9+Av4tiI/wiJRD2HeXkmFPBVuhICCoFZCql4SRfXZLqTLeHo54AWM62Go
YOh5jwOx7XH1lAwqTSDDshdgHXloxcuLW9ohPzOjos/mRObHLaVCzIYs4/O8w8XW
zEYzkdJi9eilyPITNIkBNgQYAQgAIBYhBIztLiC3OfhfDP0Qf4HQOeNiXYFwBQJd
E6XtAhsMAAoJEIHQOeNiXYFweVwH/jkhKVTwWOnQl7CllXmAuPZoTEPDMkeGNmKh
rLRL4VLuNK7dDt+aHUgNB2TqTT76/fViEwm3/3pbhygfeEEEy5T6cIzgR3qD1MCW
FJBFB3ENjZthIedg/jAtnUkwHdIv28Sx9RL4z41hLpXGRpWjiinAzoAwHGgV9CP7
jUWzk5WSTrw7p/hF3Ycid3QOcZAm9MUXWINNG89u2ZTuETTzzLGkaQe514u2dqyp
dJmM+fNpXSDjKMpeWxlgNLw9zIVJ+GjUVfsgew/ALE9lwSpxFRrqpDonlf0H83T0
3SIPibrk16hzsMER2/OAr0hQynAbk3S37Sl9YuGzwBl0zETtFs8=
=yXPi
-----END PGP PRIVATE KEY BLOCK-----''';

const publicKey = '''-----BEGIN PGP PUBLIC KEY BLOCK-----
mQENBF0Tpe0BCADm+ja4vMKuodkQEhLm/092M/6gt4TaKwzv8QcA53/FrM3g8wab
oksgIN1T+CscKXOY9GeJ530sBZgu9kTsMeQW3Uf76smo2CV1W7kSTMU+XE5ExGET
+LhkKeHpXoLfZNegKuzH1Qo7DGDOByVrnijbZIukonGwvC/MTduxb69ub+YRhWJc
fCjpMhm4WsC4h0Oz3ir5kx6NsN7XGVT5ghR9OEV6jlFmJ1nYYQxMlBGiATN5f2VR
Y/T9QBLOEsLNvK4OqviLVvgPTQZBePoCeL73CxTbqVhcamvFRVicivl8AphDLATn
1HlIjsTtbH5I/STb8UUdL+4ziRzsQukEw++xABEBAAG0WFRlc3QgQ2xpZW50IFBy
ZXBhZ28gKExsYXZlIGRlIGNsaWVudGUgdXRpbGl6YWRhIGVuIHRlc3QgYXV0b21h
dGl6YWRvcykgPGNsaWVudEB0ZXN0LmNvbT6JAU4EEwEIADgWIQSM7S4gtzn4Xwz9
EH+B0DnjYl2BcAUCXROl7QIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCB
0DnjYl2BcI1HB/94YttYwwEDYeaD51gX9QamH2DsayAqPsKyEHmgsJdJcCK27sPb
EjrI3g8sKze2aG6hPgY+FjLp/sCXWayt8N1wN7U7gnFCu2cszykyTKMwTuZs06w5
LEWWWZG3WcbVU4EdNVN0sCYr1OfgQiI9CT7/H5HZM12m5u4Qgw+9CFyMBb9sPjMw
KBMHnQLkp/J0Fmiy5KTdZL+o28lfttAOJDg+ZTChs0LWnvZCrLKquIkX7ugI85iZ
leehaFWX5Bx9w9D06uERbFlWxlonR94aA9oX9rjXcaNZeDRSpHqh5JlTMSrXXT1k
LVNLZieBhA033eNaPwMFuKyAlnVBV9d/Qz7guQENBF0Tpe0BCAD3L3Wizb8XHQAb
UXPqUe4Uc3YpRCXr/1wkIe7atDIP0Y74uxeklHMPFhxO+8pBL/bDrh+4ojdjDW8R
uE3tgSTDp5Jx4YG32dHwpoTZ1n9N8Fc58MY3zju3n2J3N86vNkST/qDzKEf7SUfi
u+KE0x3+U0QUostL9iVJXa4zg+te0yTqCt8IzGbQ6g6qCNxbbb9bZi+xDdl8z3f+
+oYIMhakixuwgDsWMblbLH7yE0gkMzEP5P5C1MsR7Ty1rtKL6RPsPvqbCXjiqI2y
iRrwAFEX1zQhqZrFRyVkzM1uQRGqFV9IDDowK44kxezumS7JLFgrZzrQFY0oOhpz
oNrWxkalABEBAAGJATYEGAEIACAWIQSM7S4gtzn4Xwz9EH+B0DnjYl2BcAUCXROl
7QIbDAAKCRCB0DnjYl2BcHlcB/45ISlU8Fjp0JewpZV5gLj2aExDwzJHhjZioay0
S+FS7jSu3Q7fmh1IDQdk6k0++v31YhMJt/96W4coH3hBBMuU+nCM4Ed6g9TAlhSQ
RQdxDY2bYSHnYP4wLZ1JMB3SL9vEsfUS+M+NYS6VxkaVo4opwM6AMBxoFfQj+41F
s5OVkk68O6f4Rd2HInd0DnGQJvTFF1iDTRvPbtmU7hE088yxpGkHudeLtnasqXSZ
jPnzaV0g4yjKXlsZYDS8PcyFSfho1FX7IHsPwCxPZcEqcRUa6qQ6J5X9B/N09N0i
D4m65Neoc7DBEdvzgK9IUMpwG5N0t+0pfWLhs8AZdMxE7RbP
=kbtq
-----END PGP PUBLIC KEY BLOCK-----''';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final encryptController = TextEditingController();
  final encryptSymmetricController = TextEditingController();
  final signController = TextEditingController();
  KeyPair _keyPair = KeyPair(
    privateKey: "",
    publicKey: "",
  );
  String _encrypted = "";
  String _decrypted = "";
  String _encryptedSymmetric = "";
  String _decryptedSymmetric = "";
  String _signed = "";
  bool _verified = false;

  @override
  void initState() {
    super.initState();
    print(publicKey);
  }

  @override
  void dispose() {
    encryptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_keyPair == null) {
      return Container();
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OpenPGP example app'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Message"),
                      controller: encryptController,
                    ),
                    RaisedButton(
                      child: Text("Encrypt"),
                      onPressed: () async {
                        var encrypted = await OpenPGP.encrypt(
                          encryptController.text,
                          publicKey,
                        );
                        setState(() {
                          _encrypted = encrypted;
                        });
                      },
                    ),
                    Text(_encrypted)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Decrypt"),
                      onPressed: () async {
                        var decrypted = await OpenPGP.decrypt(
                          _encrypted,
                          privateKey,
                          passphrase,
                        );
                        setState(() {
                          _decrypted = decrypted;
                        });
                      },
                    ),
                    Text(_decrypted)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Message"),
                      controller: signController,
                    ),
                    RaisedButton(
                      child: Text("Sign"),
                      onPressed: () async {
                        var signed = await OpenPGP.sign(
                          signController.text,
                          publicKey,
                          privateKey,
                          passphrase,
                        );
                        setState(() {
                          _signed = signed;
                        });
                      },
                    ),
                    Text(_signed)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Verify"),
                      onPressed: () async {
                        var verified = await OpenPGP.verify(
                          _signed,
                          signController.text,
                          publicKey,
                        );
                        setState(() {
                          _verified = verified;
                        });
                      },
                    ),
                    Text(_verified ? "VALID" : "INVALID")
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: "Message"),
                      controller: encryptSymmetricController,
                    ),
                    RaisedButton(
                      child: Text("Encrypt Symmetric"),
                      onPressed: () async {
                        var encrypted = await OpenPGP.encryptSymmetric(
                          encryptSymmetricController.text,
                          passphrase,
                        );
                        setState(() {
                          _encryptedSymmetric = encrypted;
                        });
                      },
                    ),
                    Text(_encryptedSymmetric)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Decrypt Symmetric"),
                      onPressed: () async {
                        var decrypted = await OpenPGP.decryptSymmetric(
                          _encryptedSymmetric,
                          passphrase,
                        );
                        setState(() {
                          _decryptedSymmetric = decrypted;
                        });
                      },
                    ),
                    Text(_decryptedSymmetric)
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Card(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Generate"),
                      onPressed: () async {
                        var keyPair = await OpenPGP.generate(
                            options: Options(
                          name: 'test',
                          email: 'test@test.com',
                          passphrase: 'test',
                          keyOptions: KeyOptions(
                            rsaBits: 1024,
                          ),
                        ));
                        setState(() {
                          _keyPair = keyPair;
                        });
                      },
                    ),
                    Text(_keyPair.publicKey),
                    Text(_keyPair.privateKey)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
