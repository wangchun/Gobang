import java.applet.Applet;
import java.applet.AudioClip;
import java.awt.Button;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Image;
import java.awt.Label;
import java.awt.MediaTracker;
import java.awt.Panel;
import java.awt.TextArea;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.awt.image.ImageObserver;
import java.awt.image.MemoryImageSource;
import java.awt.image.PixelGrabber;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Random;

public class Gobang extends Applet implements Runnable
{
	static final int IMGCOUNT = 16;
	static final int IMG_BACKGROUND = 1;
	static final int IMG_TITLE = 2;
	static final int IMG_MENUCOLORPLAYER1 = 3;
	static final int IMG_MENUCOLORPLAYER2 = 4;
	static final int IMG_MENUCOLORREADME = 5;
	static final int IMG_MENUCOLORHOMEPAGE = 6;
	static final int IMG_MENUBWPLAYER1 = 7;
	static final int IMG_MENUBWPLAYER2 = 8;
	static final int IMG_MENUBWREADME = 9;
	static final int IMG_MENUBWHOMEPAGE = 10;
	static final int IMG_CHOOSEBLACK = 11;
	static final int IMG_CHOOSEWHITE = 12;
	static final int IMG_CHESSBOARD = 13;
	static final int IMG_CHESSMANBLACK = 14;
	static final int IMG_CHESSMANWHITE = 15;
	static final String S_COPYRIGHT = "版权所有(C)   王纯   1996年11月16日—2000年08月17日   保留所有权利";
	static final String[]imageFiles = {"Images/Loading.jpeg", "Images/Background.jpeg", "Images/Title.gif", "Images/MenuColorPlayer1.gif", "Images/MenuColorPlayer2.gif", "Images/MenuColorReadme.gif", "Images/MenuColorHomepage.gif", "Images/MenuBWPlayer1.gif", "Images/MenuBWPlayer2.gif", "Images/MenuBWReadme.gif", "Images/MenuBWHomepage.gif", "Images/ChooseBlack.gif", "Images/ChooseWhite.gif", "Images/Chessboard.gif", "Images/ChessmanBlack.gif", "Images/ChessmanWhite.gif"};

	boolean menuEnabled;
	boolean computer[];
	int winFlag;
	int player;
	int chessboard[];
	Random random;
	Thread thread;
	AudioClip audioClip;
	Image offImage;
	Graphics offGraphics;
	Image images[];
	TextArea readmeTextArea;
	MenuThread menuThread;
	MenuPanel menuPanel[];
	ReadmeButton readmeButton;
	ChoosePanel choosePanel[];
	ChessboardPanel chessboardPanel;
	ExitButton exitButton;
	Computer com;

	public void fatalError(String s)
	{
		removeAll();
		offGraphics.setColor(Color.black);
		offGraphics.fillRect(0, 0, 800, 600);
		offGraphics.setColor(Color.white);
		offGraphics.setFont(new Font("宋体", Font.BOLD, 16));
		offGraphics.drawString(s, (800 - offGraphics.getFontMetrics().stringWidth(s)) / 2, (600 - offGraphics.getFontMetrics().getHeight()) / 2 + offGraphics.getFontMetrics().getAscent());
		getGraphics().drawImage(offImage, 0, 0, this);
		while(true);
	}

	public void init()
	{
		computer = new boolean[2];
		chessboard = new int[15 * 15];
		random = new Random();
		images = new Image[IMGCOUNT];
		menuPanel = new MenuPanel[4];
		choosePanel = new ChoosePanel[2];
		com = new Computer(this);
		setBackground(Color.black);
		offImage = createImage(800, 600);
		offGraphics = offImage.getGraphics();
		offGraphics.setColor(Color.black);
		offGraphics.fillRect(0, 0, 800, 600);
	}

	public void start()
	{
		thread = new Thread(this);
		thread.start();
	}

	public void run()
	{
		loading();
		menu();
	}

	public void stop()
	{
		thread = null;
	}

	public void destroy()
	{
		int i;
		for(i = 0; i < IMGCOUNT; i++)
		{
			images[i] = null;
		}
		offGraphics = null;
		offImage = null;
		System.gc();
	}

	public void paint(Graphics g)
	{
		g.drawImage(offImage, 0, 0, this);
	}

	public void update(Graphics g)
	{
		paint(g);
	}

	public String getAppletInfo()
	{
		return "五子棋   版本 7.0\n" + S_COPYRIGHT;
	}

	public int getRed(int pixel)
	{
		return (pixel >> 16) & 0xff;
	}

	public int getGreen(int pixel)
	{
		return (pixel >> 8) & 0xff;
	}

	public int getBlue(int pixel)
	{
		return pixel & 0xff;
	}

	public int getPixel(int r, int g, int b)
	{
		return 0xff000000 | r << 16 | g << 8 | b;
	}

	public void delay(long millis)
	{
		try
		{
			Thread.sleep(millis);
		}
		catch(InterruptedException e)
		{
			fatalError("异常错误 InterruptedException 在 Gobang.delay");
		}
	}

	public int[] image2pixels(Image img, int w, int h)
	{
		int i;
		int j;
		int pixels[];
		PixelGrabber pixelGrabber;
		pixels = new int[w * h];
		pixelGrabber = new PixelGrabber(img, 0, 0, w, h, pixels, 0, w);
		try
		{
			pixelGrabber.grabPixels();
		}
		catch(InterruptedException e)
		{
			fatalError("异常错误 InterruptedException 在 Gobang.image2pixels");
		}
		if((pixelGrabber.getStatus() & ImageObserver.ABORT) != 0)
		{
			fatalError("错误在 Gobang.image2pixels");
		}
		return pixels;
	}

	public Image pixels2image(int[] pixels, int w, int h)
	{
		return createImage(new MemoryImageSource(w, h, pixels, 0, w));
	}

	public void loadFiles()
	{
		int i;
		MediaTracker mediaTracker;
		mediaTracker = new MediaTracker(this);
		for(i = 1; i < IMGCOUNT; i++)
		{
			offGraphics.setColor(Color.white);
			offGraphics.drawString("正在加载 " + imageFiles[i] + "...", 4, 550 + offGraphics.getFontMetrics().getAscent());
			repaint();
			images[i] = getImage(getCodeBase(), imageFiles[i]);
			mediaTracker.addImage(images[i], i);
			try
			{
				mediaTracker.waitForID(i);
			}
			catch(InterruptedException e)
			{
				fatalError("异常错误 InterruptedException 在 Gobang.loadFiles");
			}
			images[i] = pixels2image(image2pixels(images[i], images[i].getWidth(this), images[i].getHeight(this)), images[i].getWidth(this), images[i].getHeight(this));
			delay(100);
			offGraphics.setColor(new Color(0x00, 0x99, 0xff));
			offGraphics.fillRect(0, 566, 800 * i / (IMGCOUNT - 1), 6);
			offGraphics.setColor(Color.black);
			offGraphics.fillRect(0, 550, 800, offGraphics.getFontMetrics().getHeight());
		}
		offGraphics.setColor(Color.white);
		offGraphics.drawString("完成", 4, 550 + offGraphics.getFontMetrics().getAscent());
		repaint();
		delay(500);
		offGraphics.setColor(Color.black);
		offGraphics.fillRect(0, 550, 800, offGraphics.getFontMetrics().getHeight());
		offGraphics.fillRect(0, 566, 800, 6);
		repaint();
	}
	
	public void loading()
	{
		int i;
		int w;
		int h;
		int p[];
		int pixels[];
		long time;
		double percent;
		MediaTracker tracker;
		tracker = new MediaTracker(this);
		images[0] = getImage(getCodeBase(), imageFiles[0]);
		tracker.addImage(images[0], 0);
		try
		{
			tracker.waitForID(0);
		}
		catch(InterruptedException e)
		{
			fatalError("异常错误 InterruptedException 在 Gobang.loading");
		}
		offGraphics.setFont(new Font("宋体", 0, 12));
		offGraphics.setColor(Color.white);
		offGraphics.drawString(S_COPYRIGHT, (800 - offGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + offGraphics.getFontMetrics().getAscent());
		w = images[0].getWidth(this);
		h = images[0].getHeight(this);
		p = new int[w * h];
		pixels = image2pixels(images[0], w, h);
		time = System.currentTimeMillis();
		do
		{
			if((percent = (System.currentTimeMillis() - time) / 500.0) > 1)
			{
				percent = 1;
			}
			for(i = 0; i < w * h; i++)
			{
				p[i] = getPixel((int)Math.round(getRed(pixels[i]) * percent), (int)Math.round(getGreen(pixels[i]) * percent), (int)Math.round(getBlue(pixels[i]) * percent));
			}
			offGraphics.drawImage(pixels2image(p, w, h), (800 - w) / 2, (600 - h) / 2, this);
			repaint();
		}
		while(percent < 1);
		loadFiles();
		time = System.currentTimeMillis();
		do
		{
			if((percent = (System.currentTimeMillis() - time) / 500.0) > 1)
			{
				percent = 1;
			}
			for(i = 0; i < w * h; i++)
			{
				p[i] = getPixel((int)Math.round(getRed(pixels[i]) * (1 - percent)), (int)Math.round(getGreen(pixels[i]) * (1 - percent)), (int)Math.round(getBlue(pixels[i]) * (1 - percent)));
			}
			offGraphics.drawImage(pixels2image(p, w, h), (800 - w) / 2, (600 - h) / 2, this);
			repaint();
		}
		while(percent < 1);
		System.gc();
	}

	public void menu()
	{
		long time;
		Image sourceImage;
		Graphics sourceGraphics;
		audioClip = getAudioClip(getCodeBase(), "Menu.au");
		audioClip.loop();
		sourceImage = createImage(800, 600);
		sourceGraphics = sourceImage.getGraphics();
		sourceGraphics.drawImage(images[IMG_BACKGROUND], 0, 0, this);
		sourceGraphics.drawImage(images[IMG_TITLE], (800 - images[IMG_TITLE].getWidth(this)) / 2, 80, this);
		sourceGraphics.setFont(new Font("宋体", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		sourceGraphics.setFont(new Font("宋体", Font.BOLD, 16));
		sourceGraphics.setColor(Color.cyan);
		sourceGraphics.drawString("◆ 按<ALT>+<F4>键退出 ◆", (800 - sourceGraphics.getFontMetrics().stringWidth("◆ 按<ALT>+<F4>键退出 ◆")) / 2, 320 + sourceGraphics.getFontMetrics().getAscent());
		offGraphics.drawImage(sourceImage, 0, 0, this);
		repaint();
		menuPanel[0] = new MenuPanel(IMG_MENUCOLORPLAYER1, IMG_MENUBWPLAYER1, 1, 64, 364, this);
		menuPanel[1] = new MenuPanel(IMG_MENUCOLORPLAYER2, IMG_MENUBWPLAYER2, 2, 128, 472, this);
		menuPanel[2] = new MenuPanel(IMG_MENUCOLORREADME, IMG_MENUBWREADME, 3, 672, 364, this);
		menuPanel[3] = new MenuPanel(IMG_MENUCOLORHOMEPAGE, IMG_MENUBWHOMEPAGE, 4, 608, 472, this);
		menuPanel[0].setCursor(new Cursor(Cursor.HAND_CURSOR));
		menuPanel[1].setCursor(new Cursor(Cursor.HAND_CURSOR));
		menuPanel[2].setCursor(new Cursor(Cursor.HAND_CURSOR));
		menuPanel[3].setCursor(new Cursor(Cursor.HAND_CURSOR));
		add(menuPanel[0]);
		add(menuPanel[1]);
		add(menuPanel[2]);
		add(menuPanel[3]);
		menuPanel[0].repaint();
		menuPanel[1].repaint();
		menuPanel[2].repaint();
		menuPanel[3].repaint();
		menuEnabled = true;
		time = System.currentTimeMillis();
		while(menuEnabled)
		{
			if(System.currentTimeMillis() - time >= 10000)
			{
				menuEnabled = false;
			}
		}
		if(System.currentTimeMillis() - time >= 10000)
		{
			remove(menuPanel[0]);
			remove(menuPanel[1]);
			remove(menuPanel[2]);
			remove(menuPanel[3]);
			computer[0] = computer[1] = true;
			startPlay();
		}
		System.gc();
	}

	public void processMenu(int choose)
	{
		String s;
		switch(choose)
		{
			case 1:
			{
				menuEnabled = false;
				menuPanel[0].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[1].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[2].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[3].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				choosePanel[0] = new ChoosePanel(IMG_CHOOSEBLACK, 1, 128, 364, this);
				choosePanel[1] = new ChoosePanel(IMG_CHOOSEWHITE, 2, 128, 404, this);
				add(choosePanel[0]);
				add(choosePanel[1]);
				choosePanel[0].repaint();
				choosePanel[1].repaint();
				break;
			}
			case 2:
			{
				menuEnabled = false;
				remove(menuPanel[0]);
				remove(menuPanel[1]);
				remove(menuPanel[2]);
				remove(menuPanel[3]);
				computer[0] = computer[1] = false;
				startPlay();
				break;
			}
			case 3:
			{
				menuEnabled = false;
				menuPanel[0].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[1].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[2].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				menuPanel[3].setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
				s = "";
				s += "五子棋 7.0 (测试版) 使用说明\n";
				s += "============================\n";
				s += "\n";
				s += "版权所有(C)   王纯   1996年11月16日—2000年08月17日   保留所有权利\n";
				s += "\n";
				s += "    本游戏是一个免费软件，你可以复制和使用它而不必向作者支付任何费用或\n";
				s += "事先通知作者。\n";
				s += "    本游戏使用的编程语言是Java，如果有错误报告、改进建议或者想要程序的\n";
				s += "源代码，可与作者联系。人工智能、历史记录、联机对战和禁手支持尚未完成。\n";
				s += "\n";
				s += "电子信箱：wcwcwwc@263.net\n";
				s += "个人主页：http://wcwcwwc.yeah.net\n";
				s += "\n";
				s += "◆ 软件简介 ◆\n";
				s += "\n";
				s += "    你所得到的这个版本是本游戏的第七版(测试版)。\n";
				s += "    本游戏各版本简介如下：\n";
				s += "        版本      完成日期      编程语言\n";
				s += "        V1.0   1996年11月16日   Visual BASIC 3.0\n";
				s += "        V2.0   1997年11月29日   Quick BASIC 4.5\n";
				s += "        V3.0    1998年2月1日    Borland Pascal 7.0\n";
				s += "        V4.0    1998年5月5日    Visual BASIC 3.0\n";
				s += "        V5.0    1998年8月6日    Borland Pascal 7.0\n";
				s += "        V6.0   1999年7月29日    Borland Pascal 7.0\n";
				s += "    本版本是第七版的测试版。人工智能、历史记录、联机对战和禁手支持尚未\n";
				s += "完成。它使用Java语言设计，可以不加修改地在各操作系统上顺利执行，还可以\n";
				s += "在Internet Explorer中执行，如果你愿意，甚至可以将这个软件设置为活动桌\n";
				s += "面。\n";
				s += "\n";
				s += "◆ 使用方法 ◆\n";
				s += "\n";
				s += "    要执行本游戏，你应该保证你的系统有：\n";
				s += "        486DX/66处理器，建议使用Pentium II 350MHz或更好的处理器；\n";
				s += "        800X600，256色显示，建议使用真彩色；\n";
				s += "        Windows兼容鼠标或其它指针设备；\n";
				s += "        32MB内存(Windows 9X)，64MB内存(Windows 2000专业版)，128MB内存\n";
				s += "(Windows 2000服务器版)；\n";
				s += "        如果你正在使用Windows 95，请确保已经安装了Internet Explorer \n";
				s += "4.01或更高版本。\n";
				s += "    在游戏的主菜单中，有四个项目：\n";
				s += "    ※ 人机对弈\n";
				s += "        选择此项后，游戏将首先使用黑棋还是白棋，选定后即可开始游戏。\n";
				s += "    ※ 双人对弈\n";
				s += "        选择此项可以进行双人游戏。\n";
				s += "    ※ 使用说明\n";
				s += "        选择此项可以阅读使用说明。\n";
				s += "    ※ 作者主页\n";
				s += "        选择此项可以访问作者主页。\n";
				s += "    如果主菜单出现后10秒内未选择以上任何一项，则开始计算机之间的演示性\n";
				s += "对弈。\n";
				s += "\n";
				s += "◆ 游戏规则 ◆\n";
				s += "\n";
				s += "    五子棋，亦称“串珠”、“连五子”，日文称之为“五石”、“ごもくな\n";
				s += "ら”、“れんじゅ”，英文则称之为“Gobang”、“mo-rphion”、“Renju”或\n";
				s += "“FIR(Five In A Row的缩写)”，是中国民间非常熟知的一个古老棋种。相传，\n";
				s += "它起源于四千多年前的尧帝时期，比围棋的历史还要悠久。\n";
				s += "    五子棋这一活动在其发展中经过不断的改良，其重要的规则改革包括：\n";
				s += "        1899年规定，禁止黑白双方走“双三”\n";
				s += "        1903年规定，只禁止持先的黑方走“双三”\n";
				s += "        1912年规定，如果黑方被逼迫走成“双三”，那么，黑方就立刻输了\n";
				s += "        1916年规定，禁止黑方走长连\n";
				s += "        1918年规定，禁止黑方走“四、三、三”，但是，黑方若走成“五、\n";
				s += "三、三”则为赢棋\n";
				s += "        1931年规定，禁止黑方走“双四”，同时提议把五子棋的棋盘从19×19\n";
				s += "的围棋棋盘改为15×15的五子棋专用棋盘\n";
				s += "        ……\n";
				s += "    五子棋棋盘为十五路，呈正方形，平面上画横竖各15条平行线，线路为黑\n";
				s += "色，构成225个交叉点，棋盘正中一点为“天元”，周围四点为“小星”。\n";
				s += "    五子棋比赛规则如下：\n";
				s += "    ※黑先、白后，从天元开始相互顺序落子\n";
				s += "    ※最先在棋盘横向、竖向、斜向形成连续的相同色五个棋子的一方为胜\n";
				s += "    ※黑棋禁手判负，白棋无禁手。黑棋禁手包括“三、三”、“四、四”。\n";
				s += "“长连”判负\n";
				s += "    ※如分不出胜负，则定为平局\n";
				s += "    ※对局中拔子、中途退场均判为负\n";
				s += "    ※五连与禁手同时形成，先五为胜\n";
				s += "    ※黑方禁手形成时，白方应立即指出。若白方发现而继续应子，不能判黑方\n";
				s += "负\n";
				s += "\n";
				s += "                                                     王  纯\n";
				s += "                                                 2000年08月17日\n";
				readmeTextArea = new TextArea(s);
				readmeButton = new ReadmeButton("关闭", this);
				readmeTextArea.setLocation(176, 80);
				readmeTextArea.setSize(448, 364);
				readmeTextArea.setBackground(Color.white);
				readmeTextArea.setFont(new Font("宋体", 0, 12));
				readmeTextArea.setEditable(false);
				readmeButton.setLocation(360, 460);
				readmeButton.setSize(80, 20);
				readmeButton.setFont(new Font("宋体", 0, 12));
				add(readmeTextArea);
				add(readmeButton);
				readmeTextArea.repaint();
				readmeButton.repaint();
				break;
			}
			case 4:
			{
				try
				{
					getAppletContext().showDocument(new URL("http://wcwcwwc.yeah.net"), "_BLANK");
				}
				catch(MalformedURLException e)
				{
					fatalError("异常错误 MalformedURLException 在 Gobang.processMenu");
				}
			}
		}
		System.gc();
	}

	public void processChoose(int choose)
	{
		remove(menuPanel[0]);
		remove(menuPanel[1]);
		remove(menuPanel[2]);
		remove(menuPanel[3]);
		remove(choosePanel[0]);
		remove(choosePanel[1]);
		computer[0] = (choose != 1);
		computer[1] = (choose != 2);
		startPlay();
		System.gc();
	}

	public void startPlay()
	{
		int i;
		Image sourceImage;
		Graphics sourceGraphics;
		audioClip.stop();
		audioClip = getAudioClip(getCodeBase(), "Background.au");
		audioClip.loop();
		sourceImage = createImage(800, 600);
		sourceGraphics = sourceImage.getGraphics();
		sourceGraphics.drawImage(images[IMG_BACKGROUND], 0, 0, this);
		sourceGraphics.setFont(new Font("宋体", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		offGraphics.drawImage(sourceImage, 0, 0, this);
		repaint();
		chessboardPanel = new ChessboardPanel(208, 108, this);
		exitButton = new ExitButton("退出", this);
		exitButton.setLocation(680, 560);
		exitButton.setSize(80, 20);
		exitButton.setFont(new Font("宋体", 0, 12));
		add(chessboardPanel);
		add(exitButton);
		chessboardPanel.repaint();
		exitButton.repaint();
		player = 0;
		for(i = 0; i < 15 * 15; i++)
		{
			chessboard[i] = -1;
		}
		winFlag = 0;
		com.startFlag = true;
		processPlay(7, 7);
		System.gc();
	}

	public void processPlay(int x, int y)
	{
		if(winFlag != 0)
		{
			return;
		}
		chessboard[y * 15 + x] = player;
		chessboardPanel.repaint();
		System.gc();
		com.initComputer();
		if(com.hasWin(1))
		{
			offGraphics.setColor(Color.white);
			offGraphics.setFont(new Font("宋体", Font.BOLD, 16));
			if(player == 0)
			{
				offGraphics.drawString("黑方获胜", (800 - offGraphics.getFontMetrics().stringWidth("黑方获胜")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
			}
			else
			{
				offGraphics.drawString("白方获胜", (800 - offGraphics.getFontMetrics().stringWidth("白方获胜")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
			}
			repaint();
			menuThread = new MenuThread(this, true);
			menuThread.start();
			return;
		}
		player = (player + 1) % 2;
		if(computer[player])
		{
			winFlag = 3;
			setCursor(new Cursor(Cursor.WAIT_CURSOR));
			chessboardPanel.setCursor(new Cursor(Cursor.WAIT_CURSOR));
			com.computerMove(x, y);
			if(computer[(player + 1) % 2])
			{
				delay(2000);
			}
			setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			chessboardPanel.setCursor(new Cursor(Cursor.HAND_CURSOR));
			if(winFlag == 4)
			{
				menuThread = new MenuThread(this, false);
				menuThread.start();
				return;
			}
			winFlag = 0;
			processPlay(com.resultX, com.resultY);
		}
	}
}

class MenuThread extends Thread
{
	Gobang parent;
	boolean flag;

	public MenuThread(Gobang parent, boolean flag)
	{
		this.parent = parent;
		this.flag = flag;
	}

	public void run()
	{
		long time;
		if(flag)
		{
			time = System.currentTimeMillis();
			parent.winFlag = 1;
			while(System.currentTimeMillis() - time < 10000 && parent.winFlag == 1);
		}
		parent.remove(parent.chessboardPanel);
		parent.remove(parent.exitButton);
		parent.audioClip.stop();
		parent.menu();
	}
}

class ReadmeButton extends Button implements ActionListener
{
	Gobang parent;

	public ReadmeButton(String label, Gobang parent)
	{
		setLabel(label);
		this.parent = parent;
		addActionListener(this);
	}

	public void actionPerformed(ActionEvent e)
	{
		parent.remove(parent.readmeTextArea);
		parent.remove(parent.readmeButton);
		parent.menuEnabled = true;
		parent.menuPanel[0].setCursor(new Cursor(Cursor.HAND_CURSOR));
		parent.menuPanel[1].setCursor(new Cursor(Cursor.HAND_CURSOR));
		parent.menuPanel[2].setCursor(new Cursor(Cursor.HAND_CURSOR));
		parent.menuPanel[3].setCursor(new Cursor(Cursor.HAND_CURSOR));
	}
}

class ExitButton extends Button implements ActionListener
{
	Gobang parent;

	public ExitButton(String label, Gobang parent)
	{
		setLabel(label);
		this.parent = parent;
		addActionListener(this);
	}

	public void actionPerformed(ActionEvent e)
	{
		if(parent.winFlag == 0)
		{
			parent.menuThread = new MenuThread(parent, false);
			parent.menuThread.start();
		}
		if(parent.winFlag == 1)
		{
			parent.winFlag = 2;
		}
		if(parent.winFlag == 3)
		{
			parent.winFlag = 4;
		}
	}
}

class MenuPanel extends Panel implements MouseListener, MouseMotionListener
{
	boolean hot;
	boolean pressed;
	int imageColor;
	int imageBW;
	int code;
	int x;
	int y;
	Gobang parent;

	public MenuPanel(int imageColor, int imageBW, int code, int x, int y, Gobang parent)
	{
		this.imageColor = imageColor;
		this.imageBW = imageBW;
		this.code = code;
		this.x = x;
		this.y = y;
		this.parent = parent;
		hot = false;
		pressed = false;
		setLocation(x, y);
		setSize(64, 80);
		addMouseListener(this);
		addMouseMotionListener(this);
	}

	public void paint(Graphics g)
	{
		Image image;
		Graphics graphics;
		image = createImage(64, 80);
		graphics = image.getGraphics();
		graphics.drawImage(parent.images[parent.IMG_BACKGROUND], -x, -y, this);
		if(hot && parent.menuEnabled)
		{
			if(pressed)
			{
				graphics.drawImage(parent.images[imageColor], 1, 1, this);
				graphics.setColor(Color.darkGray);
				graphics.drawLine(0, 0, 63, 0);
				graphics.drawLine(0, 0, 0, 78);
				graphics.setColor(Color.white);
				graphics.drawLine(0, 79, 63, 79);
				graphics.drawLine(63, 1, 63, 79);
			}
			else
			{
				graphics.drawImage(parent.images[imageColor], 0, 0, this);
				graphics.setColor(Color.white);
				graphics.drawLine(0, 0, 63, 0);
				graphics.drawLine(0, 0, 0, 78);
				graphics.setColor(Color.darkGray);
				graphics.drawLine(0, 79, 63, 79);
				graphics.drawLine(63, 1, 63, 79);
			}
		}
		else
		{
			graphics.drawImage(parent.images[imageBW], 0, 0, this);
		}
		g.drawImage(image, 0, 0, this);
		System.gc();
	}

	public void update(Graphics g)
	{
		paint(g);
	}

	public void mouseClicked(MouseEvent e)
	{
	}

	public void mouseEntered(MouseEvent e)
	{
		hot = true;
		repaint();
	}

	public void mouseExited(MouseEvent e)
	{
		hot = false;
		repaint();
	}

	public void mousePressed(MouseEvent e)
	{
		if((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0 && (e.getModifiers() & MouseEvent.BUTTON2_MASK) == 0 && (e.getModifiers() & MouseEvent.BUTTON3_MASK) == 0)
		{
			hot = (e.getX() >= 0 && e.getY() >= 0 && e.getX() < 64 && e.getY() < 80);
			pressed = true;
			repaint();
		}
	}

	public void mouseReleased(MouseEvent e)
	{
		if((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0 && (e.getModifiers() & MouseEvent.BUTTON2_MASK) == 0 && (e.getModifiers() & MouseEvent.BUTTON3_MASK) == 0)
		{
			hot = (e.getX() >= 0 && e.getY() >= 0 && e.getX() < 64 && e.getY() < 80);
			pressed = false;
			repaint();
			if(parent.menuEnabled && hot)
			{
				parent.processMenu(code);
			}
		}
	}

	public void mouseDragged(MouseEvent e)
	{
		if(hot)
		{
			if(e.getX() < 0 || e.getY() < 0 || e.getX() >= 64 || e.getY() >= 80)
			{
				hot = false;
				repaint();
			}
		}
		else
		{
			if(e.getX() >= 0 && e.getY() >= 0 && e.getX() < 64 && e.getY() < 80)
			{
				hot = true;
				repaint();
			}
		}
	}

	public void mouseMoved(MouseEvent e)
	{
		if(hot)
		{
			if(e.getX() < 0 || e.getY() < 0 || e.getX() >= 64 || e.getY() >= 80)
			{
				hot = false;
				repaint();
			}
		}
		else
		{
			if(e.getX() >= 0 && e.getY() >= 0 && e.getX() < 64 && e.getY() < 80)
			{
				hot = true;
				repaint();
			}
		}
	}
}

class ChoosePanel extends Panel implements MouseListener, MouseMotionListener
{
	boolean hot;
	boolean pressed;
	int image;
	int code;
	int x;
	int y;
	Gobang parent;

	public ChoosePanel(int image, int code, int x, int y, Gobang parent)
	{
		this.image = image;
		this.code = code;
		this.x = x;
		this.y = y;
		this.parent = parent;
		hot = false;
		pressed = false;
		setLocation(x, y);
		setSize(120, 40);
		setCursor(new Cursor(Cursor.HAND_CURSOR));
		addMouseListener(this);
		addMouseMotionListener(this);
	}

	public void paint(Graphics g)
	{
		Image img;
		Graphics graphics;
		img = createImage(120, 40);
		graphics = img.getGraphics();
		graphics.drawImage(parent.images[parent.IMG_BACKGROUND], -x, -y, this);
		if(hot)
		{
			if(pressed)
			{
				graphics.drawImage(parent.images[image], 1, 1, this);
				graphics.setColor(Color.darkGray);
				graphics.drawLine(0, 0, 119, 0);
				graphics.drawLine(0, 0, 0, 38);
				graphics.setColor(Color.white);
				graphics.drawLine(0, 39, 119, 39);
				graphics.drawLine(119, 1, 119, 39);
			}
			else
			{
				graphics.drawImage(parent.images[image], 0, 0, this);
				graphics.setColor(Color.white);
				graphics.drawLine(0, 0, 119, 0);
				graphics.drawLine(0, 0, 0, 38);
				graphics.setColor(Color.darkGray);
				graphics.drawLine(0, 39, 119, 39);
				graphics.drawLine(119, 1, 119, 39);
			}
		}
		else
		{
			graphics.drawImage(parent.images[image], 0, 0, this);
		}
		g.drawImage(img, 0, 0, this);
		System.gc();
	}

	public void update(Graphics g)
	{
		paint(g);
	}

	public void mouseClicked(MouseEvent e)
	{
	}

	public void mouseEntered(MouseEvent e)
	{
		hot = true;
		repaint();
	}

	public void mouseExited(MouseEvent e)
	{
		hot = false;
		repaint();
	}

	public void mousePressed(MouseEvent e)
	{
		if((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0 && (e.getModifiers() & MouseEvent.BUTTON2_MASK) == 0 && (e.getModifiers() & MouseEvent.BUTTON3_MASK) == 0)
		{
			hot = (e.getX() >= 0 && e.getY() >= 0 && e.getX() < 120 && e.getY() < 40);
			pressed = true;
			repaint();
		}
	}

	public void mouseReleased(MouseEvent e)
	{
		if((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0 && (e.getModifiers() & MouseEvent.BUTTON2_MASK) == 0 && (e.getModifiers() & MouseEvent.BUTTON3_MASK) == 0)
		{
			hot = (e.getX() >= 0 && e.getY() >= 0 && e.getX() < 120 && e.getY() < 40);
			pressed = false;
			repaint();
			if(hot)
			{
				parent.processChoose(code);
			}
		}
	}

	public void mouseDragged(MouseEvent e)
	{
		if(hot)
		{
			if(e.getX() < 0 || e.getY() < 0 || e.getX() >= 120 || e.getY() >= 40)
			{
				hot = false;
				repaint();
			}
		}
		else
		{
			if(e.getX() >= 0 && e.getY() >= 0 && e.getX() < 120 && e.getY() < 40)
			{
				hot = true;
				repaint();
			}
		}
	}

	public void mouseMoved(MouseEvent e)
	{
		if(hot)
		{
			if(e.getX() < 0 || e.getY() < 0 || e.getX() >= 120 || e.getY() >= 40)
			{
				hot = false;
				repaint();
			}
		}
		else
		{
			if(e.getX() >= 0 && e.getY() >= 0 && e.getX() < 120 && e.getY() < 40)
			{
				hot = true;
				repaint();
			}
		}
	}
}

class ChessboardPanel extends Panel implements MouseListener
{
	int x;
	int y;
	Gobang parent;

	public ChessboardPanel(int x, int y, Gobang parent)
	{
		int i;
		int j;
		int p[];
		int pixels[];
		this.x = x;
		this.y = y;
		this.parent = parent;
		setLocation(x, y);
		setSize(384, 384);
		setCursor(new Cursor(Cursor.HAND_CURSOR));
		addMouseListener(this);
	}

	public void paint(Graphics g)
	{
		int i;
		int j;
		Image image;
		Graphics graphics;
		image = createImage(384, 384);
		graphics = image.getGraphics();
		graphics.drawImage(parent.images[parent.IMG_CHESSBOARD], 0, 0, this);
		for(i = 0; i < 15; i++)
		{
			for(j = 0; j < 15; j++)
			{
				if(parent.chessboard[j * 15 + i] == 0)
				{
					graphics.drawImage(parent.images[parent.IMG_CHESSMANBLACK], i * 24 + 23, j * 24 + 8, this);
				}
				if(parent.chessboard[j * 15 + i] == 1)
				{
					graphics.drawImage(parent.images[parent.IMG_CHESSMANWHITE], i * 24 + 23, j * 24 + 8, this);
				}
			}
		}
		g.drawImage(image, 0, 0, this);
		System.gc();
	}

	public void update(Graphics g)
	{
		paint(g);
	}

	public void mouseClicked(MouseEvent e)
	{
	}

	public void mouseEntered(MouseEvent e)
	{
	}

	public void mouseExited(MouseEvent e)
	{
	}

	public void mousePressed(MouseEvent e)
	{
		int i;
		int j;
		if(parent.winFlag == 0)
		{
			if((e.getModifiers() & MouseEvent.BUTTON1_MASK) != 0 && (e.getModifiers() & MouseEvent.BUTTON2_MASK) == 0 && (e.getModifiers() & MouseEvent.BUTTON3_MASK) == 0)
			{
				if(!parent.computer[parent.player])
				{
					i = (e.getX() + 5) / 24 - 1;
					j = (e.getY() + 20) / 24 - 1;
					if(i >= 0 && i < 15 && j >= 0 && j < 15 && parent.chessboard[j * 15 + i] == -1)
					{
						parent.processPlay(i, j);
					}
				}
			}
		}
		if(parent.winFlag == 1)
		{
			parent.winFlag = 2;
		}
	}

	public void mouseReleased(MouseEvent e)
	{
	}
}

class Computer
{
	static final int MAXDEPTH = 3;
	static final int LEAST = 3;
	static final int SAVING = 3;
	static final int direction[] = {0, 1, 1, 1, 1, 0, 1, -1};
	static final double valueStandard[] = {0.01, 0.05, 0.2, 1, 0.5, 2, 20, 0, 30, 200, 0, 0, 1000000, 0, 0, 0};

	boolean startFlag;
	int resultX;
	int resultY;
	int map[];
	double value;
	double valueMap[];
	Gobang parent;

	public Computer(Gobang parent)
	{
		this.parent = parent;
		map = new int[17 * 17];
		valueMap = new double[17 * 17];
	}

	public void initComputer()
	{
		int i;
		int j;
		for(i = 0; i < 17 * 17; i++)
		{
			map[i] = 0;
		}
		if(parent.player == 0)
		{
			for(i = 1; i <= 15; i++)
			{
				for(j = 1; j <= 15; j++)
				{
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == -1)
					{
						map[j * 17 + i] = 0;
					}
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == 0)
					{
						map[j * 17 + i] = 1;
					}
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == 1)
					{
						map[j * 17 + i] = 2;
					}
				}
			}
		}
		else
		{
			for(i = 1; i <= 15; i++)
			{
				for(j = 1; j <= 15; j++)
				{
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == -1)
					{
						map[j * 17 + i] = 0;
					}
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == 0)
					{
						map[j * 17 + i] = 2;
					}
					if(parent.chessboard[(j - 1) * 15 + (i - 1)] == 1)
					{
						map[j * 17 + i] = 1;
					}
				}
			}
		}
	}

	public void processMove(int x, int y)
	{
		int i;
		int j;
		double m;
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				if(map[j * 17 + i] == 0 && chessman(i, j))
				{
					map[j * 17 + i] = 1;
					if(hasWin(1))
					{
						resultX = i;
						resultY = j;
						return;
					}
					map[j * 17 + i] = 0;
				}
			}
		}
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				if(map[j * 17 + i] == 0 && chessman(i, j))
				{
					map[j * 17 + i] = 2;
					if(hasWin(2))
					{
						resultX = i;
						resultY = j;
						return;
					}
					map[j * 17 + i] = 0;
				}
			}
		}
		if((value = search(1, 1, Double.MAX_VALUE)) == -Double.MAX_VALUE)
		{
			calculate(1);
			m = -1;
			for(i = 1; i <= 15; i++)
			{
				for(j = 1; j <= 15; j++)
				{
					if(map[j * 17 + i] == 0)
					{
						if(valueMap[j * 17 + i] > m)
						{
							m = valueMap[j * 17 + i];
							resultX = i;
							resultY = j;
							return;
						}
					}
				}
			}
		}
	}

	public void computerMove(int x, int y)
	{
		int i;
		int j;
		int t;
		t = 0;
		initComputer();
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				if(map[j * 17 + i] != 0)
				{
					t++;
				}
			}
		}
		if(t <= 4)
		{
			do
			{
				resultX = (int)Math.floor(parent.random.nextDouble() * 15);
				resultY = (int)Math.floor(parent.random.nextDouble() * 15);
			}
			while(map[(resultY + 1) * 17 + (resultX + 1)] != 0 || !chessman(resultX + 1, resultY + 1));
			return;
		}
		processMove(x, y);
		resultX--;
		resultY--;
	}

	public boolean hasWin(int player)
	{
		int i;
		int j;
		int k;
		int l;
		boolean flag;
		boolean ss[];
		int s[];
		ss = new boolean[256];
		s = new int[6];
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(k = 1; k <= 4; k++)
				{
					if(i + direction[(k - 1) * 2] * 4 >= 1 && i + direction[(k - 1) * 2] * 4 <= 15 && j + direction[(k - 1) * 2 + 1] * 4 >= 1 && j + direction[(k - 1) * 2 + 1] * 4 <= 15)
					{
						for(l = 0; l <= 4; l++)
						{
							s[l + 1] = map[(j + direction[(k - 1) * 2 + 1] * l) * 17 + (i + direction[(k - 1) * 2] * l)];
						}
						flag = true;
						for(l = 1; l <= 5; l++)
						{
							if(s[l] != player)
							{
								flag = false;
							}
						}
						if(flag)
						{
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	public double calc(int player)
	{
		int i;
		int j;
		int k;
		int l;
		int m;
		int n;
		int temp;
		double t;
		boolean ss[];
		int s1[];
		double s2[];
		int f[];
		ss = new boolean[256];
		s1 = new int[6];
		s2 = new double[6];
		f = new int[3 * 16 * 16 * 5 * 5];
		for(i = 0; i < 3 * 16 * 16 * 5 * 5; i++)
		{
			f[i] = 0;
		}
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(k = 1; k <= 4; k++)
				{
					if(i + direction[(k - 1) * 2] * 4 >= 1 && i + direction[(k - 1) * 2] * 4 <= 15 && j + direction[(k - 1) * 2 + 1] * 4 >= 1 && j + direction[(k - 1) * 2 + 1] * 4 <= 15)
					{
						for(l = 0; l <= 4; l++)
						{
							s1[l + 1] = map[(j + direction[(k - 1) * 2 + 1] * l) * 17 + (i + direction[(k - 1) * 2] * l)];
						}
						for(l = 0; l < 256; l++)
						{
							ss[l] = false;
						}
						for(l = 1; l <= 5; l++)
						{
							ss[s1[l]] = true;
						}
						ss[0] = false;
						temp = 0;
						for(l = 0; l < 256; l++)
						{
							if(ss[l])
							{
								temp++;
							}
						}
						if(temp == 1 && (ss[1] || ss[2]))
						{
							if(ss[1])
							{
								m = 1;
							}
							else
							{
								m = 2;
							}
							n = 0;
							for(l = 1; l <= 5; l++)
							{
								if(s1[l] != 0)
								{
									n++;
								}
							}
							for(l = 0; l <= 4; l++)
							{
								if(s1[l + 1] == 0)
								{
									f[m * 16 * 16 * 5 * 5 + (i + direction[(k - 1) * 2] * l) * 16 * 5 * 5 + (j + direction[(k - 1) * 2 + 1] * l) * 5 * 5 + n * 5 + k]++;
								}
							}
						}
					}
				}
			}
		}
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(m = 1; m <= 2; m++)
				{
					if(m == player)
					{
						t = 1;
					}
					else
					{
						t = 0.9;
					}
					for(n = 1; n <= 4; n++)
					{
						for(k = 1; k <= 4; k++)
						{
							if(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] != 0)
							{
								valueMap[j * 17 + i] = valueMap[j * 17 + i] + valueStandard[(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] - 1) * 4 + (n - 1)];
							}
						}
					}
				}
			}
		}
		t = 0;
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(m = 1; m <= 2; m++)
				{
					for(n = 1; n <= 4; n++)
					{
						for(k = 1; k <= 4; k++)
						{
							if(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] != 0)
							{
								if(m == player)
								{
									t += valueStandard[(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] - 1) * 4 + (n - 1)];
								}
								else
								{
									t -= valueStandard[(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] - 1) * 4 + (n - 1)];
								}
							}
						}
					}
				}
			}
		}
		return t;
	}

	public void calculate(int player)
	{
		int i;
		int j;
		int k;
		int l;
		int m;
		int n;
		int temp;
		double t;
		boolean ss[];
		int s1[];
		double s2[];
		int f[];
		ss = new boolean[256];
		s1 = new int[6];
		s2 = new double[6];
		f = new int[3 * 16 * 16 * 5 * 5];
		for(i = 0; i < 17 * 17; i++)
		{
			valueMap[i] = 0;
		}
		for(i = 0; i < 3 * 16 * 16 * 5 * 5; i++)
		{
			f[i] = 0;
		}
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(k = 1; k <= 4; k++)
				{
					if(i + direction[(k - 1) * 2] * 4 >= 1 && i + direction[(k - 1) * 2] * 4 <= 15 && j + direction[(k - 1) * 2 + 1] * 4 >= 1 && j + direction[(k - 1) * 2 + 1] * 4 <= 15)
					{
						for(l = 0; l <= 4; l++)
						{
							s1[l + 1] = map[(j + direction[(k - 1) * 2 + 1] * l) * 17 + (i + direction[(k - 1) * 2] * l)];
						}
						for(l = 0; l < 256; l++)
						{
							ss[l] = false;
						}
						for(l = 1; l <= 5; l++)
						{
							ss[s1[l]] = true;
						}
						ss[0] = false;
						temp = 0;
						for(l = 0; l < 256; l++)
						{
							if(ss[l])
							{
								temp++;
							}
						}
						if(temp == 1 && (ss[1] || ss[2]))
						{
							if(ss[1])
							{
								m = 1;
							}
							else
							{
								m = 2;
							}
							n = 0;
							for(l = 1; l <= 5; l++)
							{
								if(s1[l] != 0)
								{
									n++;
								}
							}
							for(l = 0; l <= 4; l++)
							{
								if(s1[l + 1] == 0)
								{
									f[m * 16 * 16 * 5 * 5 + (i + direction[(k - 1) * 2] * l) * 16 * 5 * 5 + (j + direction[(k - 1) * 2 + 1] * l) * 5 * 5 + n * 5 + k]++;
								}
							}
						}
					}
				}
			}
		}
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				for(m = 1; m <= 2; m++)
				{
					if(m == player)
					{
						t = 1;
					}
					else
					{
						t = 0.9;
					}
					for(n = 1; n <= 4; n++)
					{
						for(k = 1; k <= 4; k++)
						{
							if(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] != 0)
							{
								valueMap[j * 17 + i] += valueStandard[(f[m * 16 * 16 * 5 * 5 + i * 16 * 5 * 5 + j * 5 * 5 + n * 5 + k] - 1) * 4 + (n - 1)];
							}
						}
					}
				}
			}
		}
	}

	public double search(int depth, int player, double mark)
	{
		int i;
		int j;
		int k;
		int m;
		int mi;
		int mj;
		int st;
		int mw;
		double max2;
		double min;
		double min2;
		double ss2[];
		int ss[];
		ss2 = new double[SAVING + 1];
		ss = new int[SAVING * 2];
		if(depth >= MAXDEPTH)
		{
			return calc(1);
		}
		calculate(player);
		st = 0;
		max2 = 0;
		min2 = 0;
		mw = 0;
		for(i = 1; i <= 15; i++)
		{
			for(j = 1; j <= 15; j++)
			{
				if(map[j * 17 + i] == 0 && valueMap[j * 17 + i] > 0)
				{
					if(st == SAVING)
					{
						if(valueMap[j * 17 + i] > min2)
						{
							m = mw;
							ss2[m] = valueMap[j * 17 + i];
							if(ss2[m] > max2)
							{
								max2 = ss2[m];
								mi = i;
								mj = j;
							}
							ss[(m - 1) * 2] = i;
							ss[(m - 1) * 2 + 1] = j;
							min2 = ss2[1];
							mw = 1;
							for(k = 2; k <= st; k++)
							{
								if(ss2[k] < min2)
								{
									min2 = ss2[k];
									mw = k;
								}
							}
						}
					}
					else
					{
						st++;
						ss[(st - 1) * 2] = i;
						ss[(st - 1) * 2 + 1] = j;
						ss2[st] = valueMap[j * 17 + i];
						if(valueMap[j * 17 + i] > max2)
						{
							mi = i;
							mj = j;
							max2 = valueMap[j * 17 + i];
						}
						min2 = ss2[1];
						mw = 1;
						for(k = 2; k <= st; k++)
						{
							if(ss2[k] < min2)
							{
								min2 = ss2[k];
								mw = k;
							}
						}
					}
				}
			}
		}
		for(i = 1; i <= st; i++)
		{
			for(j = i + 1; j <= st; j++)
			{
				if(ss2[i] < ss2[j])
				{
					m = ss[(i - 1) * 2];
					ss[(i - 1) * 2] = ss[(j - 1) * 2];
					ss[(j - 1) * 2] = m;
					m = ss[(i - 1) * 2 + 1];
					ss[(i - 1) * 2 + 1] = ss[(j - 1) * 2 + 1];
					ss[(j - 1) * 2 + 1] = m;
					min = ss2[i];
					ss2[i] = ss2[j];
					ss2[j] = min;
				}
			}
		}
		if(startFlag)
		{
			st = 2;
			startFlag = false;
		}
		if(st > LEAST)
		{
			st = LEAST;
		}
		max2 = -Double.MAX_VALUE;
		if((depth & 0x01) == 0)
		{
			max2 = Double.MAX_VALUE;
		}
		for(m = 1; m <= st; m++)
		{
			i = ss[(m - 1) * 2];
			j = ss[(m - 1) * 2 + 1];
			map[j * 17 + i] = player;
			if(hasWin(player))
			{
				if(depth == 1)
				{
					resultX = i;
					resultY = j;
				}
				map[j * 17 + i] = 0;
				if((depth & 2) == 0x01)
				{
					return Double.MAX_VALUE;
				}
				else
				{
					return -Double.MAX_VALUE;
				}
			}
			min = search(depth + 1, 3 - player, max2);
			map[j * 17 + i] = 0;
			if((depth & 0x01) == 1)
			{
				if(min > max2)
				{
					max2 = min;
					if(depth == 1)
					{
						resultX = i;
						resultY = j;
					}
				}
				if(max2 >= mark)
				{
					return max2;
				}
			}
			else
			{
				if(min < max2)
				{
					max2 = min;
				}
				if(max2 <= mark)
				{
					return max2;
				}
			}
		}
		return max2;
	}

	public boolean chessman(int x, int y)
	{
		if(map[y * 17 + (x + 1)] != 0)
		{
			return true;
		}
		if(map[y * 17 + (x - 1)] != 0)
		{
			return true;
		}
		if(map[(y + 1) * 17 + x] != 0)
		{
			return true;
		}
		if(map[(y - 1) * 17 + x] != 0)
		{
			return true;
		}
		if(map[(y + 1) * 17 + (x + 1)] != 0)
		{
			return true;
		}
		if(map[(y - 1) * 17 + (x + 1)] != 0)
		{
			return true;
		}
		if(map[(y - 1) * 17 + (x - 1)] != 0)
		{
			return true;
		}
		if(map[(y + 1) * 17 + (x - 1)] != 0)
		{
			return true;
		}
		return false;
	}
}