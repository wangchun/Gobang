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
	static final String S_COPYRIGHT = "��Ȩ����(C)   ����   1996��11��16�ա�2000��08��17��   ��������Ȩ��";
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
		offGraphics.setFont(new Font("����", Font.BOLD, 16));
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
		return "������   �汾 7.0\n" + S_COPYRIGHT;
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
			fatalError("�쳣���� InterruptedException �� Gobang.delay");
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
			fatalError("�쳣���� InterruptedException �� Gobang.image2pixels");
		}
		if((pixelGrabber.getStatus() & ImageObserver.ABORT) != 0)
		{
			fatalError("������ Gobang.image2pixels");
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
			offGraphics.drawString("���ڼ��� " + imageFiles[i] + "...", 4, 550 + offGraphics.getFontMetrics().getAscent());
			repaint();
			images[i] = getImage(getCodeBase(), imageFiles[i]);
			mediaTracker.addImage(images[i], i);
			try
			{
				mediaTracker.waitForID(i);
			}
			catch(InterruptedException e)
			{
				fatalError("�쳣���� InterruptedException �� Gobang.loadFiles");
			}
			images[i] = pixels2image(image2pixels(images[i], images[i].getWidth(this), images[i].getHeight(this)), images[i].getWidth(this), images[i].getHeight(this));
			delay(100);
			offGraphics.setColor(new Color(0x00, 0x99, 0xff));
			offGraphics.fillRect(0, 566, 800 * i / (IMGCOUNT - 1), 6);
			offGraphics.setColor(Color.black);
			offGraphics.fillRect(0, 550, 800, offGraphics.getFontMetrics().getHeight());
		}
		offGraphics.setColor(Color.white);
		offGraphics.drawString("���", 4, 550 + offGraphics.getFontMetrics().getAscent());
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
			fatalError("�쳣���� InterruptedException �� Gobang.loading");
		}
		offGraphics.setFont(new Font("����", 0, 12));
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
		sourceGraphics.setFont(new Font("����", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		sourceGraphics.setFont(new Font("����", Font.BOLD, 16));
		sourceGraphics.setColor(Color.cyan);
		sourceGraphics.drawString("�� ��<ALT>+<F4>���˳� ��", (800 - sourceGraphics.getFontMetrics().stringWidth("�� ��<ALT>+<F4>���˳� ��")) / 2, 320 + sourceGraphics.getFontMetrics().getAscent());
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
				s += "������ 7.0 (���԰�) ʹ��˵��\n";
				s += "============================\n";
				s += "\n";
				s += "��Ȩ����(C)   ����   1996��11��16�ա�2000��08��17��   ��������Ȩ��\n";
				s += "\n";
				s += "    ����Ϸ��һ��������������Ը��ƺ�ʹ����������������֧���κη��û�\n";
				s += "����֪ͨ���ߡ�\n";
				s += "    ����Ϸʹ�õı��������Java������д��󱨸桢�Ľ����������Ҫ�����\n";
				s += "Դ���룬����������ϵ���˹����ܡ���ʷ��¼��������ս�ͽ���֧����δ��ɡ�\n";
				s += "\n";
				s += "�������䣺wcwcwwc@263.net\n";
				s += "������ҳ��http://wcwcwwc.yeah.net\n";
				s += "\n";
				s += "�� ������ ��\n";
				s += "\n";
				s += "    �����õ�������汾�Ǳ���Ϸ�ĵ��߰�(���԰�)��\n";
				s += "    ����Ϸ���汾������£�\n";
				s += "        �汾      �������      �������\n";
				s += "        V1.0   1996��11��16��   Visual BASIC 3.0\n";
				s += "        V2.0   1997��11��29��   Quick BASIC 4.5\n";
				s += "        V3.0    1998��2��1��    Borland Pascal 7.0\n";
				s += "        V4.0    1998��5��5��    Visual BASIC 3.0\n";
				s += "        V5.0    1998��8��6��    Borland Pascal 7.0\n";
				s += "        V6.0   1999��7��29��    Borland Pascal 7.0\n";
				s += "    ���汾�ǵ��߰�Ĳ��԰档�˹����ܡ���ʷ��¼��������ս�ͽ���֧����δ\n";
				s += "��ɡ���ʹ��Java������ƣ����Բ����޸ĵ��ڸ�����ϵͳ��˳��ִ�У�������\n";
				s += "��Internet Explorer��ִ�У������Ը�⣬�������Խ�����������Ϊ���\n";
				s += "�档\n";
				s += "\n";
				s += "�� ʹ�÷��� ��\n";
				s += "\n";
				s += "    Ҫִ�б���Ϸ����Ӧ�ñ�֤���ϵͳ�У�\n";
				s += "        486DX/66������������ʹ��Pentium II 350MHz����õĴ�������\n";
				s += "        800X600��256ɫ��ʾ������ʹ�����ɫ��\n";
				s += "        Windows������������ָ���豸��\n";
				s += "        32MB�ڴ�(Windows 9X)��64MB�ڴ�(Windows 2000רҵ��)��128MB�ڴ�\n";
				s += "(Windows 2000��������)��\n";
				s += "        ���������ʹ��Windows 95����ȷ���Ѿ���װ��Internet Explorer \n";
				s += "4.01����߰汾��\n";
				s += "    ����Ϸ�����˵��У����ĸ���Ŀ��\n";
				s += "    �� �˻�����\n";
				s += "        ѡ��������Ϸ������ʹ�ú��廹�ǰ��壬ѡ���󼴿ɿ�ʼ��Ϸ��\n";
				s += "    �� ˫�˶���\n";
				s += "        ѡ�������Խ���˫����Ϸ��\n";
				s += "    �� ʹ��˵��\n";
				s += "        ѡ���������Ķ�ʹ��˵����\n";
				s += "    �� ������ҳ\n";
				s += "        ѡ�������Է���������ҳ��\n";
				s += "    ������˵����ֺ�10����δѡ�������κ�һ���ʼ�����֮�����ʾ��\n";
				s += "���ġ�\n";
				s += "\n";
				s += "�� ��Ϸ���� ��\n";
				s += "\n";
				s += "    �����壬��ơ����顱���������ӡ������ĳ�֮Ϊ����ʯ���������⤯��\n";
				s += "�顱������󤸤塱��Ӣ�����֮Ϊ��Gobang������mo-rphion������Renju����\n";
				s += "��FIR(Five In A Row����д)�������й����ǳ���֪��һ���������֡��ഫ��\n";
				s += "����Դ����ǧ����ǰ��Ң��ʱ�ڣ���Χ�����ʷ��Ҫ�ƾá�\n";
				s += "    ��������һ����䷢չ�о������ϵĸ���������Ҫ�Ĺ���ĸ������\n";
				s += "        1899��涨����ֹ�ڰ�˫���ߡ�˫����\n";
				s += "        1903��涨��ֻ��ֹ���ȵĺڷ��ߡ�˫����\n";
				s += "        1912��涨������ڷ��������߳ɡ�˫��������ô���ڷ�����������\n";
				s += "        1916��涨����ֹ�ڷ��߳���\n";
				s += "        1918��涨����ֹ�ڷ��ߡ��ġ��������������ǣ��ڷ����߳ɡ��塢\n";
				s += "����������ΪӮ��\n";
				s += "        1931��涨����ֹ�ڷ��ߡ�˫�ġ���ͬʱ���������������̴�19��19\n";
				s += "��Χ�����̸�Ϊ15��15��������ר������\n";
				s += "        ����\n";
				s += "    ����������Ϊʮ��·���������Σ�ƽ���ϻ�������15��ƽ���ߣ���·Ϊ��\n";
				s += "ɫ������225������㣬��������һ��Ϊ����Ԫ������Χ�ĵ�Ϊ��С�ǡ���\n";
				s += "    ����������������£�\n";
				s += "    �����ȡ��׺󣬴���Ԫ��ʼ�໥˳������\n";
				s += "    �����������̺�������б���γ���������ͬɫ������ӵ�һ��Ϊʤ\n";
				s += "    ����������и��������޽��֡�������ְ������������������ġ��ġ���\n";
				s += "���������и�\n";
				s += "    ����ֲ���ʤ������Ϊƽ��\n";
				s += "    ���Ծ��а��ӡ���;�˳�����Ϊ��\n";
				s += "    �����������ͬʱ�γɣ�����Ϊʤ\n";
				s += "    ���ڷ������γ�ʱ���׷�Ӧ����ָ�������׷����ֶ�����Ӧ�ӣ������кڷ�\n";
				s += "��\n";
				s += "\n";
				s += "                                                     ��  ��\n";
				s += "                                                 2000��08��17��\n";
				readmeTextArea = new TextArea(s);
				readmeButton = new ReadmeButton("�ر�", this);
				readmeTextArea.setLocation(176, 80);
				readmeTextArea.setSize(448, 364);
				readmeTextArea.setBackground(Color.white);
				readmeTextArea.setFont(new Font("����", 0, 12));
				readmeTextArea.setEditable(false);
				readmeButton.setLocation(360, 460);
				readmeButton.setSize(80, 20);
				readmeButton.setFont(new Font("����", 0, 12));
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
					fatalError("�쳣���� MalformedURLException �� Gobang.processMenu");
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
		sourceGraphics.setFont(new Font("����", 0, 12));
		sourceGraphics.setColor(Color.white);
		sourceGraphics.drawString(S_COPYRIGHT, (800 - sourceGraphics.getFontMetrics().stringWidth(S_COPYRIGHT)) / 2, 580 + sourceGraphics.getFontMetrics().getAscent());
		offGraphics.drawImage(sourceImage, 0, 0, this);
		repaint();
		chessboardPanel = new ChessboardPanel(208, 108, this);
		exitButton = new ExitButton("�˳�", this);
		exitButton.setLocation(680, 560);
		exitButton.setSize(80, 20);
		exitButton.setFont(new Font("����", 0, 12));
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
			offGraphics.setFont(new Font("����", Font.BOLD, 16));
			if(player == 0)
			{
				offGraphics.drawString("�ڷ���ʤ", (800 - offGraphics.getFontMetrics().stringWidth("�ڷ���ʤ")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
			}
			else
			{
				offGraphics.drawString("�׷���ʤ", (800 - offGraphics.getFontMetrics().stringWidth("�׷���ʤ")) / 2, 520 + offGraphics.getFontMetrics().getAscent());
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