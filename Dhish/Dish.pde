class Dish implements Runnable
{
  private PVector loc;
  private ArrayList cells;

  private static final float sunlight = 1;
  private float animalCostMod, defMod, viscosity, visibility;

  public float progress;//the progress of the dish to splitting

  public Dish()
  {
    loc = ORIGIN.get();//cursor.get();
    cells = new ArrayList();

    animalCostMod = modify(1);
    defMod = modify(1);
    visibility = modify(1);
    viscosity = modify(1);

    progress = 0;
  }

  public Dish(int plants, int animals)
  {
    this();

    for (int p = 0; p < plants; p++)
      add(new Plant());
    for (int a = 0; a < animals; a++)
      add(new Animal());

    for (int k = 0; k < cells.size(); k++)
      get(k).myDish = this;
  }

  public Dish(int plants, int animals, int rocks)
  {
    this(plants, animals);

    for (int r = 0; r < rocks; r++)
      add(new Rock());

    for (int k = 0; k < cells.size(); k++)
      get(k).myDish = this;
  }

  public Dish(Dish p)//only for dish evolution mode, has glithces
  {
    this();
    loc = p.loc.get();
    animalCostMod = modify(p.animalCostMod);
    defMod = modify(p.defMod);
    visibility = modify(p.visibility);
    viscosity = modify(p.viscosity);
  }

  public float modify(float num)
  {
    return num * pow(1.3, random(-1, 1));
  }

  public void run()
  {

    for (int k = 0; k < cells.size(); k++)
      ((Cell)get(k)).run();//runs the cells

    if (dishEvolution)
    {
      progress += (quality()-avgQuality())/100;

      if (progress > TWO_PI)
      {
        if (dishes.size() != 1)
          killWorstDish();
        devide();
      }
    }

    if (animalWeight() <= 0 || plantWeight() <= 0)
      die();

    for (int k = 0; k < dishes.size(); k++)
    {
      Dish d = (Dish)dishes.get(k);

      if (touching(d))
      {
        if (dist(d) == 0 && d != this)
          d.loc.add(new PVector(random(-1, 1), random(-1, 1)));//radius));//adds a small random vector, so that the distance wont be 0.

        PVector push = PVector.sub(d.loc, loc);
        push.limit((1+(2*radius) - dist(d))/3.0);
        d.loc.add(push);
      }
    }
  }

  public void show()
  {
    translate(loc);


    int s = size();
    PVector v = new PVector();
    for (int k = 0; k < s; k++)
    {
      color c = get(k).myColor;
      PVector values = new PVector(red(c), green(c), blue(c));

      if (get(k) instanceof Animal)
        values.mult(5);


      v.add(values);
    }
    v.div(s);
    color avg = color(v.x, v.y, v.z);

    fill(hue(avg), 100/zoom, 365, 50);



    stroke(200);
    strokeWeight(10);
    ellipse(radius*2);

    for (int k = 0; k < cells.size(); k++)
      ((Cell)get(k)).show();//shows all the cells

    if (progress > 0 && dishEvolution)
    {
      fill(255, 0);
      strokeWeight(10);
      stroke(255);
      arc(0, 0, radius*2, radius*2, -PI/2, progress - PI/2);
    }
  }

  public float avgAnimalWeight()
  {
    float weight = 0;
    for (int k = 0; k < dishes.size(); k++)
    {
      Dish d = (Dish)dishes.get(k);
      weight += d.animalWeight();
    }

    return weight/dishes.size();
  }

  public float avgQuality()
  {
    float total = 0;

    for (int k = 0; k < dishes.size(); k++)
    {
      Dish d = (Dish)dishes.get(k);
      total += d.quality();
    }

    return total/dishes.size();
  }

  public float quality()
  {
    float score = 0;
    for (int k = 0; k < size(); k++)
      if (get(k) instanceof Animal)
      {
        Animal a = (Animal)get(k);
        score += a.livingCost;
      }
    return score;
  }

  public float animalWeight()
  {
    float weight = 0;
    for (int k = 0; k < size(); k++)
      if (get(k) instanceof Animal)
        weight += get(k).w;
    return weight;
  }
  public float plantWeight()
  {
    float weight = 0;
    for (int k = 0; k < size(); k++)
      if (get(k) instanceof Plant)
        weight += get(k).w;
    return weight;
  }

  protected void devide()
  {
    Dish d1 = new Dish(this);
    Dish d2 = new Dish(this);

    while (size () > 0)
    {
      Cell c = remove(size()-1);

      if (random(1) > .5)
        d1.add(c);
      else
        d2.add(c);
    }

    die();
    dishes.add(d1);
    dishes.add(d2);
  }

  public void killWorstDish()
  {
    int worst = 0;
    for (int k = 1; k < dishes.size(); k++)
      if (((Dish)dishes.get(k)).quality() < ((Dish)dishes.get(worst)).quality())
        worst = k;
    dishes.remove(worst);
  }

  public float dist(Dish d)
  {
    return loc.dist(d.loc);
  }

  public boolean touching(Dish d)
  {
    return loc.dist(d.loc) < 2*radius && d != this;
  }

  public String toString()
  {
    return "  "+animalCostMod+"  "+defMod+"  "+visibility+"  "+viscosity+"  quality:"+quality();
  }

  private void die()
  {
    dishes.remove(this);
    //radius = 0;
  }

  public void add(Cell c)
  {
    //c.myDish = this;
    cells.add(c);
  }

  public Cell get(int index)
  {
    return (Cell)cells.get(index);
  }

  public Cell remove(Cell r)
  {
    int index = cells.indexOf(r);

    if (index != -1)
      return remove(index);
    return null;
  }
  public Cell remove(int index)
  {
    return (Cell)cells.remove(index);
  }

  public int size()
  {
    return cells.size();
  }
}

