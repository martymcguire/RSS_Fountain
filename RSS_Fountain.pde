import com.creatingwithcode.greader.GoogleReaderClient;
import com.creatingwithcode.greader.RecentItemsFeed;
import com.creatingwithcode.greader.FeedItem;

GoogleReaderClient grc;
ParticleSystem ps;
List strings;

String username = "YOUR GOOGLE USERNAME";
String password = "YOUR GOOGLE PASSWORD";
void setup() {
  PFont font;
  // http://www.1001freefonts.com/ComicBookCommando.php
  font = createFont("Comicv3", 12); 
  textFont(font); 
  
  strings = new ArrayList();
  
  String punctuation = "[.,;:!@#$%^&*() \\/<>=+-_'\"]";
  grc = new GoogleReaderClient(username, password);
  RecentItemsFeed rif = grc.getRecentItemsFeed();
  Iterator rifi = rif.getItems().iterator();
  while(rifi.hasNext()){
    FeedItem fi = (FeedItem) rifi.next();
    String summary = (String) ((fi.getSummary() == null) ? "" :
                               fi.getSummary().get("content"));
    strings.addAll(Arrays.asList(fi.getTitle().split(punctuation)));
    strings.addAll(Arrays.asList(summary.split(punctuation)));
    println(fi.getTitle());
  }
  size(640, 360);
  colorMode(RGB, 255, 255, 255, 100);
  ps = new ParticleSystem(1, new PVector(width/2,height,0));
  smooth();
}

void draw() {
  background(0);
  ps.run();
  ps.addParticle((String)strings.get(int(random(strings.size()))));
  ps.addParticle((String)strings.get(int(random(strings.size()))));
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born

  ParticleSystem(int num, PVector v) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    /*
    for (int i = 0; i < num; i++) {
      particles.add(new Particle(origin));    // Add "num" amount of particles to the arraylist
    }
    */
  }

  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  void addParticle(String s) {
    particles.add(new Particle(s,origin));
  }
  
    void addParticle(String s,float x, float y) {
    particles.add(new Particle(s,new PVector(x,y)));
  }

  void addParticle(Particle p) {
    particles.add(p);
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}




// A simple Particle class

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float timer;
  String s;
  
  // Another constructor (the one we are using here)
  Particle(String _s, PVector l) {
    s = _s;
    acc = new PVector(0,0.05,0);
    vel = new PVector(random(-2.5,2.5),random(-6,-2),0);
    loc = l.get();
    timer = 150.0;
  }

  void run() {
    update();
    render();
  }

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -= 1.0;
  }

  // Method to display
  void render() {
    ellipseMode(CENTER);
    stroke(255,timer);
    fill(255,timer);
    text(s, loc.x, loc.y); 
  }
  
  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
  

}

