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
	static final String S_COPYRIGHT = "井幡侭嗤(C)   藍歓   1996定11埖16晩！2000定08埖17晩   隠藻侭嗤幡旋";
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
		offGraphics.setFont(new Font("卜悶", Font.BOLD, 16));
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
		return "励徨薙   井云 7.0\n" + S_COPYRIGHT;
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
			fatalError("呟械危列 InterruptedException 壓 Gobang.delay");
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
			fatalError("呟械危列 InterruptedException 壓 Gobang.image2pixels");
		}
		if((pixelGrabber.getStatus() & ImageObserver.ABORT) != 0)
		{
			fatalError("危列壓 Gobang.image2pixels");
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
			offGraphics.drawString("屎壓紗墮 " + imageFiles[i] + "...", 4, 550 + offGraphics.getFontMetrics().getAscent());
			repaint();
			images[i] = getImage(getCodeBase(), imageFiles[i]);
			mediaTracker.addImage(images[i], i);
			try
			{
				mediaTracker.waitForID(i);
			}
			catch(InterruptedException e)
			{
				fatalError("呟械危列 InterruptedException 壓 Gobang.loadFiles");
			}
			images[i] = pixels2image(image2pixels(images[i], images[i].getWidth(this), images[i].getHeight(this)), images[i].getWidth(this), images[i].getHeight(this));
			delay(100);
			offGraphics.setColor(new Color(0x00, 0x99, 0xff));
			offGraphics.fillRect(0, 566, 800 * i / (IMGCOUNT - 1), 6);
			offGraphics.setColor(Color.black);
			offGraphics.fillRect(0, 550, 800, offGraphics.getFontMetrics().getHeight());
		}
		offGraphics.setColor(Color.white);
		offGraphics.drawString("頼撹", 4, 550 + offGraphics.getFontMetrics().getAscent());
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
			fatalError("呟械危列 InterruptedException 壓 Gobang.loading");
		}
		offGraphics.setFont(new Font("卜悶", 0, 12));
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
		sourceGraphics.setFont(new Font("卜悶", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		sourceGraphics.setFont(new Font("卜悶", Font.BOLD, 16));
		sourceGraphics.setColor(Color.cyan);
		sourceGraphics.drawString("＃ 梓<ALT>+<F4>囚曜竃 ＃", (800 - sourceGraphics.getFontMetrics().stringWidth("＃ 梓<ALT>+<F4>囚曜竃 ＃")) / 2, 320 + sourceGraphics.getFontMetrics().getAscent());
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
				s += "励徨薙 7.0 (霞編井) 聞喘傍苧\n";
				s += "============================\n";
				s += "\n";
				s += "井幡侭嗤(C)   藍歓   1996定11埖16晩！2000定08埖17晩   隠藻侭嗤幡旋\n";
				s += "\n";
				s += "    云嗄老頁匯倖窒継罷周��低辛參鹸崙才聞喘万遇音駅�鰈�宀屶原販採継喘賜\n";
				s += "並枠宥岑恬宀。\n";
				s += "    云嗄老聞喘議園殻囂冱頁Java��泌惚嗤危列烏御、個序秀咏賜宀�誨�殻會議\n";
				s += "坿旗鷹��辛嚥恬宀選狼。繁垢崘嬬、煽雰芝村、選字斤媾才鋤返屶隔賓隆頼撹。\n";
				s += "\n";
				s += "窮徨佚�筍�wcwcwwc@263.net\n";
				s += "倖繁麼匈��http://wcwcwwc.yeah.net\n";
				s += "\n";
				s += "＃ 罷周酒初 ＃\n";
				s += "\n";
				s += "    低侭誼欺議宸倖井云頁云嗄老議及鈍井(霞編井)。\n";
				s += "    云嗄老光井云酒初泌和��\n";
				s += "        井云      頼撹晩豚      園殻囂冱\n";
				s += "        V1.0   1996定11埖16晩   Visual BASIC 3.0\n";
				s += "        V2.0   1997定11埖29晩   Quick BASIC 4.5\n";
				s += "        V3.0    1998定2埖1晩    Borland Pascal 7.0\n";
				s += "        V4.0    1998定5埖5晩    Visual BASIC 3.0\n";
				s += "        V5.0    1998定8埖6晩    Borland Pascal 7.0\n";
				s += "        V6.0   1999定7埖29晩    Borland Pascal 7.0\n";
				s += "    云井云頁及鈍井議霞編井。繁垢崘嬬、煽雰芝村、選字斤媾才鋤返屶隔賓隆\n";
				s += "頼撹。万聞喘Java囂冱譜柴��辛參音紗俐個仇壓光荷恬狼由貧乏旋峇佩��珊辛參\n";
				s += "壓Internet Explorer嶄峇佩��泌惚低垳吭��封崛辛參繍宸倖罷周譜崔葎試強彑\n";
				s += "中。\n";
				s += "\n";
				s += "＃ 聞喘圭隈 ＃\n";
				s += "\n";
				s += "    勣峇佩云嗄老��低哘乎隠屬低議狼由嗤��\n";
				s += "        486DX/66侃尖匂��秀咏聞喘Pentium II 350MHz賜厚挫議侃尖匂��\n";
				s += "        800X600��256弼�塋升�秀咏聞喘寔科弼��\n";
				s += "        Windows惹否報炎賜凪万峺寞譜姥��\n";
				s += "        32MB坪贋(Windows 9X)��64MB坪贋(Windows 2000廨匍井)��128MB坪贋\n";
				s += "(Windows 2000捲暦匂井)��\n";
				s += "        泌惚低屎壓聞喘Windows 95��萩鳩隠厮将芦廾阻Internet Explorer \n";
				s += "4.01賜厚互井云。\n";
				s += "    壓嗄老議麼暇汽嶄��嗤膨倖�酊殖�\n";
				s += "    ☆ 繁字斤淞\n";
				s += "        僉夲緩�邵鵤�嗄老繍遍枠聞喘菜薙珊頁易薙��僉協朔軸辛蝕兵嗄老。\n";
				s += "    ☆ 褒繁斤淞\n";
				s += "        僉夲緩�鄂敏埆�佩褒繁嗄老。\n";
				s += "    ☆ 聞喘傍苧\n";
				s += "        僉夲緩�鄂敏墺超訴荒男誼�。\n";
				s += "    ☆ 恬宀麼匈\n";
				s += "        僉夲緩�鄂敏垠知遍�宀麼匈。\n";
				s += "    泌惚麼暇汽竃�嶌�10昼坪隆僉夲參貧販採匯�遑�夸蝕兵柴麻字岻寂議處幣來\n";
				s += "斤淞。\n";
				s += "\n";
				s += "＃ 嗄老号夸 ＃\n";
				s += "\n";
				s += "    励徨薙��呀各＾堪帷￣、＾銭励徨￣��晩猟各岻葎＾励墳￣、＾ごもくな\n";
				s += "ら￣、＾れんじゅ￣��哂猟夸各岻葎＾Gobang￣、＾mo-rphion￣、＾Renju￣賜\n";
				s += "＾FIR(Five In A Row議抹亟)￣��頁嶄忽酎寂掲械母岑議匯倖硬析薙嶽。�犂���\n";
				s += "万軟坿噐膨認謹定念議劬吸扮豚��曳律薙議煽雰珊勣啼消。\n";
				s += "    励徨薙宸匯試強壓凪窟婢嶄将狛音僅議個措��凪嶷勣議号夸個醐淫凄��\n";
				s += "        1899定号協��鋤峭菜易褒圭恠＾褒眉￣\n";
				s += "        1903定号協��峪鋤峭隔枠議菜圭恠＾褒眉￣\n";
				s += "        1912定号協��泌惚菜圭瓜影独恠撹＾褒眉￣��椎担��菜圭祥羨震補阻\n";
				s += "        1916定号協��鋤峭菜圭恠海銭\n";
				s += "        1918定号協��鋤峭菜圭恠＾膨、眉、眉￣��徽頁��菜圭飛恠撹＾励、\n";
				s += "眉、眉￣夸葎哺薙\n";
				s += "        1931定号協��鋤峭菜圭恠＾褒膨￣��揖扮戻咏委励徨薙議薙徒貫19〜19\n";
				s += "議律薙薙徒個葎15〜15議励徨薙廨喘薙徒\n";
				s += "        ´´\n";
				s += "    励徨薙薙徒葎噴励揃��格屎圭侘��峠中貧鮫罪抱光15訳峠佩�滷��濛稽�菜\n";
				s += "弼��更撹225倖住我泣��薙徒屎嶄匯泣葎＾爺圷￣��巓律膨泣葎＾弌佛￣。\n";
				s += "    励徨薙曳琵号夸泌和��\n";
				s += "    ☆菜枠、易朔��貫爺圷蝕兵�犹ニ覚鯊籃�\n";
				s += "    ☆恷枠壓薙徒罪�髻∧��髻∃穎鯰粒描�偬議�猴�弼励倖薙徨議匯圭葎覆\n";
				s += "    ☆菜薙鋤返登減��易薙涙鋤返。菜薙鋤返淫凄＾眉、眉￣、＾膨、膨￣。\n";
				s += "＾海銭￣登減\n";
				s += "    ☆泌蛍音竃覆減��夸協葎峠蕉\n";
				s += "    ☆斤蕉嶄偉徨、嶄余曜魁譲登葎減\n";
				s += "    ☆励銭嚥鋤返揖扮侘撹��枠励葎覆\n";
				s += "    ☆菜圭鋤返侘撹扮��易圭哘羨軸峺竃。飛易圭窟�峩�写偬哘徨��音嬬登菜圭\n";
				s += "減\n";
				s += "\n";
				s += "                                                     藍  歓\n";
				s += "                                                 2000定08埖17晩\n";
				readmeTextArea = new TextArea(s);
				readmeButton = new ReadmeButton("購液", this);
				readmeTextArea.setLocation(176, 80);
				readmeTextArea.setSize(448, 364);
				readmeTextArea.setBackground(Color.white);
				readmeTextArea.setFont(new Font("卜悶", 0, 12));
				readmeTextArea.setEditable(false);
				readmeButton.setLocation(360, 460);
				readmeButton.setSize(80, 20);
				readmeButton.setFont(new Font("卜悶", 0, 12));
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
					fatalError("呟械危列 MalformedURLException 壓 Gobang.processMenu");
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
		sourceGraphics.setFont(new Font("卜悶", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		offGraphics.drawImage(sourceImage, 0, 0, this);
		repaint();
		chessboardPanel = new ChessboardPanel(208, 108, this);
		exitButton = new ExitButton("曜竃", this);
		exitButton.setLocation(680, 560);
		exitButton.setSize(80, 20);
		exitButton.setFont(new Font("卜悶", 0, 12));
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
			offGraphics.setFont(new Font("卜悶", Font.BOLD, 16));
			if(player == 0)
			{
				offGraphics.drawString("菜圭資覆", (800 - offGraphics.getFontMetrics().stringWidth("菜圭資覆")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
			}
			else
			{
				offGraphics.drawString("易圭資覆", (800 - offGraphics.getFontMetrics().stringWidth("易圭資覆")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
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