import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * @author xYzDl
 * @date 2018-1-17 下午1:47:42
 * @desc 将数据库配置自动生成类定义,以及导出数据为XML文件
 */
public class XBuilder {
	public static final String DATA_BASE = "xyzdl.db";

	public static final String CLASS_DESC = "/**\n"
			+ " * Create by xYzDl Builder\n" + " * Table:%s" + "\n */";
	public static final String PACKAGE_NAME = "com.conf";
	public static final String EXTENDS = "";// "extends BasePo";
	public static final String COMMON = "公共";
	public static final String TABLE_PREFIX = "t_";
	public static final String FILE_SUFFIX = ".as";
	public static final String TABLE_SELECT_ST = "SELECT * FROM %s";
	public static final String FIELD = "\t\tpublic var %s:%s;\n";

	public static Map<String, String> tableDLLMap = new HashMap<String, String>();
	public static Map<String, String> typeMap = new HashMap<String, String>();

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		typeMap.put("INTEGER", "int");
		typeMap.put("TEXT", "String");
		typeMap.put("BOOLEAN", "Boolean");
		typeMap.put("REAL", "Number");

		Connection conn = getConnection();
		try {
			Statement state = conn.createStatement();
			ResultSet rs = state
					.executeQuery("SELECT * FROM sqlite_master WHERE type='table' AND name LIKE 't_%'");

			while (rs.next()) {
				System.out.println(rs.getString("name"));
				tableDLLMap.put(rs.getString("name"), rs.getString("sql"));
			}

			String protoStr = StringUtil.readToString("prototype.txt");
			if (protoStr == null)
				return;

			for (String key : tableDLLMap.keySet()) {
				ArrayList<String[]> arrayList = parseDLL2Array(tableDLLMap
						.get(key));

				String fieldStr = "";
				for (String[] strings : arrayList) {
					fieldStr += String.format(FIELD, strings[0],
							typeConvert(strings[1]));
				}

				String className = StringUtil.underlineToCamel(key)
						.substring(1);

				fieldStr = fieldStr.substring(0, fieldStr.length() - 1);

				Map<String, Object> labelMap = new HashMap<String, Object>();
				labelMap.put("classdesc", String.format(CLASS_DESC, key));
				labelMap.put("packagename", PACKAGE_NAME);
				labelMap.put("common", "");
				labelMap.put("classname", className);
				labelMap.put("extends", EXTENDS);
				labelMap.put("fields", fieldStr);

				System.out.println(StringUtil.formatLabel(protoStr, labelMap));
				contentToTxt(PACKAGE_NAME.replace('.', '/') + "/" + className
						+ FILE_SUFFIX,
						StringUtil.formatLabel(protoStr, labelMap));
			}

			// 数据导出
			File dataFile = new File("conf.data");
			PrintWriter pw;
			if (dataFile.exists()) {
				dataFile.delete();
			}

			dataFile.createNewFile();
			pw = new PrintWriter(dataFile);
			pw.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<data>");
			
			for (String key : tableDLLMap.keySet()) {
				ArrayList<String[]> arrayList = parseDLL2Array(tableDLLMap
						.get(key));
				String selectSql = "SELECT * FROM " + key;
				rs = state.executeQuery(selectSql);

				String tableStr = "<";
				pw.append("\n<" + StringUtil.underlineToCamel(key).substring(1));
				tableStr += StringUtil.underlineToCamel(key).substring(1);
				for (String[] ss : arrayList) {
					tableStr += " " + ss[0] + "=\"" + ss[0] + "\"";
					pw.append(" " + ss[0] + "=\"" + ss[0] + "\"");
				}
				tableStr += ">\n";
				pw.append(">\n");

				while (rs.next()) {
					String rowStr = "\t<row>";
					pw.append("\t<row>");
					for (String[] ss : arrayList) {
						rowStr += "<p>" + rs.getObject(ss[0]) + "</p>";
						pw.append("<p>" + rs.getObject(ss[0]) + "</p>");
					}
					rowStr += "</row>";
					pw.append("</row>\n");
					tableStr += rowStr + "\n";
				}
				tableStr += "</"
						+ StringUtil.underlineToCamel(key).substring(1) + ">";
				pw.append("</" + StringUtil.underlineToCamel(key).substring(1)
						+ ">");
			}

			pw.append("\n</data>");
			pw.flush();
			pw.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static String typeConvert(String type) {
		if (typeMap.get(type) == null) {
			return type;
		} else {
			return typeMap.get(type);
		}
	}

	public static Connection getConnection() {
		Connection c = null;
		try {
			Class.forName("org.sqlite.JDBC");
			c = DriverManager.getConnection("jdbc:sqlite:" + DATA_BASE);
			System.out.println("Opened database successfully");
		} catch (Exception e) {
			System.err.println(e.getClass().getName() + ": " + e.getMessage());
			System.exit(0);
		}
		return c;
	}

	public static ArrayList<String[]> parseDLL2Array(String ddlSql) {
		// String ddlSql =
		// "CREATE TABLE t_user (id INTEGER PRIMARY KEY ASC AUTOINCREMENT, account TEXT (20) NOT NULL, password TEXT (20) NOT NULL, isAdmin BOOLEAN NOT NULL, createDate REAL NOT NULL)";
		Pattern pattern = Pattern.compile("(?<=\\().*(?=\\))");
		Matcher matcher = pattern.matcher(ddlSql);
		ArrayList<String[]> arrayList = new ArrayList<String[]>();
		if (matcher.find()) {
			System.out.println(matcher.group());
			String matheResult = matcher.group();
			for (String field : matheResult.split(",")) {
				String[] pi = field.trim().split(" ");
				String[] result = new String[2];
				result[0] = pi[0].trim().replace("\"", "");
				result[1] = pi[1].trim().toUpperCase();
				arrayList.add(result);
			}
		}
		return arrayList;
	}

	public static void contentToTxt(String filePath, String content) {
		String str = new String(); // 原有txt内容
		String s1 = new String();// 内容更新
		try {
			File f = new File(filePath);
			if (f.exists()) {
				f.delete();
				f.createNewFile();
			} else {
				f.getParentFile().mkdirs();
				f.createNewFile();// 不存在则创建
			}
			BufferedReader input = new BufferedReader(new FileReader(f));

			while ((str = input.readLine()) != null) {
				s1 += str + "\n";
			}
			input.close();
			s1 += content;

			BufferedWriter output = new BufferedWriter(new FileWriter(f));
			output.write(s1);
			output.close();
		} catch (Exception e) {
			e.printStackTrace();

		}
	}

	public static void printArray(Object[] arr) {
		for (Object object : arr) {
			System.out.println(object);
		}
	}
}

class StringUtil {
	public static final char UNDERLINE = '_';

	/**
	 * 驼峰格式字符串转换为下划线格式字符串
	 * 
	 * @param param
	 * @return
	 */
	public static String camelToUnderline(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (Character.isUpperCase(c)) {
				sb.append(UNDERLINE);
				sb.append(Character.toLowerCase(c));
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	/**
	 * 下划线格式字符串转换为驼峰格式字符串
	 * 
	 * @param param
	 * @return
	 */
	public static String underlineToCamel(String param) {
		if (param == null || "".equals(param.trim())) {
			return "";
		}
		int len = param.length();
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++) {
			char c = param.charAt(i);
			if (c == UNDERLINE) {
				if (++i < len) {
					sb.append(Character.toUpperCase(param.charAt(i)));
				}
			} else {
				sb.append(c);
			}
		}
		return sb.toString();
	}

	public static String readToString(String fileName) {
		String encoding = "UTF-8";
		File file = new File(fileName);
		Long filelength = file.length();
		byte[] filecontent = new byte[filelength.intValue()];
		try {
			FileInputStream in = new FileInputStream(file);
			in.read(filecontent);
			in.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		try {
			return new String(filecontent, encoding);
		} catch (UnsupportedEncodingException e) {
			System.err.println("The OS does not support " + encoding);
			e.printStackTrace();
			return null;
		}
	}

	public static String format(String src, Object... args) {
		int len = args.length;
		for (int i = 0; i < len; i++) {
			src = src.replace("{" + i + "}", args[0].toString());
		}
		return src;
	}

	public static String formatLabel(String src, Map<String, Object> map) {
		for (String name : map.keySet()) {
			src = src.replace("{" + name + "}", map.get(name).toString());
		}
		return src;
	}
}