package test
{
	import com.hurlant.crypto.prng.Random;
	import com.hurlant.crypto.rsa.RSAKey;
	import com.hurlant.crypto.symmetric.AESKey;
	import com.hurlant.crypto.tests.AESKeyTest;
	import com.hurlant.crypto.tests.DESKeyTest;
	import com.hurlant.crypto.tests.RSAKeyTest;
	import com.hurlant.math.BigInteger;
	import com.hurlant.util.Hex;
	import xyzdlcore.crypt.AESCrypt;
	import xyzdlcore.utils.XStringUtil;
	import xyzdlcore.utils.XTimer;
	
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;

	public class Test4Client
	{
		public function Test4Client()
		{
//			var lt:int = 0;
//			var now:int;
//			var t:Timer = new Timer(50);
//			t.addEventListener(TimerEvent.TIMER, function():void
//			{
//				now = getTimer();
//				trace(now - lt);
//				lt = now;
//			});
//			t.start();
//			XTimer.add(function(time:int, arg:*):void
//			{
//				now = getTimer();
//				trace(now - lt + ":" + arg);
//				lt = now;
//			}, 750, true, "2");
//			XTimer.add(function(time:int, arg:*):void
//			{
//				now = getTimer();
//				trace(now - lt + ":" + arg);
//				lt = now;
//			}, 1000, true, "3");
//			XTimer.remove(temp);
			
//			testCase4AESCrypt();
			testCaseTemp();
			testCaseTemp2();
		}
		private var lt:int = 0;
		private var now:int = 0;
		private function temp(time:int, arg:*):void
		{
			now = getTimer();
			trace(now - lt + ":" + arg);
			lt = now;
		}

		public function testCaseTemp():void
		{
			var src:ByteArray = Hex.toArray("12345678");
			var en:ByteArray = new ByteArray();
			var de:ByteArray = new ByteArray();
			var rsa:RSAKey = RSAKey.generate(521, "10001");// new RSAKey(bi, 65537);
			var btn:ByteArray = rsa.n.toByteArray();//Hex.toArray("593d4ea0361d626bb5b2957d12322a73");
			var btd:ByteArray = rsa.d.toByteArray();
			trace("n:"+Hex.fromArray(btn));
			trace("d:"+Hex.fromArray(btd));
			var bi:BigInteger = new BigInteger(btn);
			trace("n:"+Hex.fromArray(rsa.n.toByteArray()));
			var rsa2:RSAKey = new RSAKey(bi, 65537);
			rsa.encrypt(src, en, src.length);
			trace("en:"+Hex.fromArray(en));
			rsa.decrypt(en, de, en.length);
			trace("de:"+Hex.fromArray(de));
		}
		
		public function testCaseTemp2():void
		{
			var src:ByteArray = Hex.toArray("593d4ea0361d626bb5b2957d12322a73");
			var en:ByteArray = Hex.toArray("2f09052811adaa68a126d53254b69312bc73e86e9a67fbff5832a25d8bf775a69048cf755d0c87c5f9fe758ed009f84cd3ab15ee66d5faa4e505932e95204c783d");
			var de:ByteArray = new ByteArray();
			var btn:ByteArray = Hex.toArray("83c0b386d645fcd33cda504e0811ac85c789567b3c3f84d91372f4bf23596acffdb58415dd4827e8c92424d42feb5b7813ef311889f5e67e2b0354dc1b66790c01");
			var btd:ByteArray = Hex.toArray("0faecb6fdc679e4da2abb5ed63e67eabb9f1ae1aa3344862f27eb7855cf6d2d10650f2805ac088030cf8238fd6af182754eea321e80fbb3a7945d3cdcd7377fab1");
			var bi:BigInteger = new BigInteger(btn);
			var bd:BigInteger = new BigInteger(btd);
			var rsa2:RSAKey = new RSAKey(bi, 65537,bd);
			rsa2.decrypt(en,de,en.length);
			trace("de:"+Hex.fromArray(de));
		}
		public function testCase4RSACrypt():void
		{
			var src:ByteArray = Hex.toArray("12345678");
			var en:ByteArray = new ByteArray();
			var de:ByteArray = new ByteArray();
			var rsa:RSAKey = RSAKey.generate(128, "10001");
			trace("pub key:" + rsa.n);
			trace("pri key:" + rsa.d);
			rsa.encrypt(src, en, src.length);
			trace("beforEn:" + Hex.fromArray(en));
			rsa.decrypt(en, de, en.length);
			trace("afterDe:" + Hex.fromArray(de));
		}

		public function testCase4AESCrypt():void
		{
			var str:String = "1234567890abcdef";
			var bs:ByteArray = new ByteArray();
			for (var i:int = 0; i < str.length; i++) 
			{
				bs.writeByte(str.charCodeAt(i));
			}
			
			trace("c:"+bs);
			
			var content:ByteArray = Hex.toArray("1234567890abcdef1234567890abcdef");
			var ac:AESCrypt = new AESCrypt();
//			ac.generateRandomAESKey();
			ac.key = bs;
			trace(Hex.fromArray(ac.key));
			ac.encryptBytes(content);
			trace(Hex.fromArray(content));
			trace(Hex.fromArray(ac.decryptBytes(content)));
		}
	}
}
import com.hurlant.crypto.tests.ITestHarness;

internal class TestHarnessBase implements ITestHarness
{

	public function beginTest(name:String):void
	{
		// TODO Auto Generated method stub
		trace("Start Test:" + name);
	}

	public function beginTestCase(name:String):void
	{
		// TODO Auto Generated method stub
		trace("Start Test Case:" + name);
	}

	public function endTestCase():void
	{
		// TODO Auto Generated method stub
		trace("End Test Case.");
	}

	public function failTest(msg:String):void
	{
		// TODO Auto Generated method stub
		trace("Test Failed:" + msg);
	}

	public function passTest():void
	{
		// TODO Auto Generated method stub
		trace("Test Successed!");
	}

}
