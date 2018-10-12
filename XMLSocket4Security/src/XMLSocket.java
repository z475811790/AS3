import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

public class XMLSocket {
	private static final String RESPONSE = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
			+ "<!DOCTYPE cross-domain-policy SYSTEM \"http://www.adobe.com/xml/dtds/cross-domain-policy.dtd\">"
			+ "<cross-domain-policy>"
			+ "<site-control permitted-cross-domain-policies=\"all\" />"
			+ "<allow-access-from domain=\"*\" to-ports=\"*\"/>"
			+ "<allow-http-request-headers-from domain=\"*\" headers=\"*\"/>"
			+ "</cross-domain-policy>\0";// 一定要注意加\0结束

	/**
	 * @param args
	 * @throws IOException
	 */
	public static void main(String[] args) throws IOException {

		File file = new File("bin");

		System.out.println(file.getAbsolutePath());
		if (file == null)
			return;
		// TODO Auto-generated method stub
		ServerSocket serverSocket = new ServerSocket(843);
		while (true) {
			out("Listening...");
			Socket socket = serverSocket.accept();
			out(new Date().toLocaleString() + "Connected from "
					+ socket.getInetAddress().getHostAddress());
			OutputStream out = socket.getOutputStream();
			PrintWriter pw = new PrintWriter(out);
			pw.write(RESPONSE);
			pw.flush();
			pw.close();
			out.close();
			socket.close();
			out("Response Over. Socket Closed");

		}
	}

	public static void out(String str) {
		System.out.println((new Date()).toString() + "#" + str);
	}
}