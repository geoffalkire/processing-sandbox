public class Brain
{
  protected Animal a;//the animal that the brain is controlling
  //protected ArrayList mem;//you can store previous good feeding locations here
  protected Cell target;
  protected Animal predator;
  protected float minDist;//the min dist between the predator and the prey, before the brain will choose to run from the predator instead of go for the food
  protected int marker;//for recognizing relatives, so as not to eat them //Is this working or not?!?!?!?!?!
 
  public Brain(Animal body)//body is the animal that the brain is controlling
  {
    a = body;
    target = a;
    predator = a;
    minDist = random(0,body.effectiveSensoryRange()*2);
    marker = (int)random(100,1000);
  }
 
  public Brain makeChild(Animal childBody)
  {
    Brain b = new Brain(childBody);
 
    b.minDist = a.modify(minDist);
 
    b.marker = marker;
    if(random(1) < .1)
      b.marker = (int)a.modify(marker);
 
    return b;
  }

  public PVector move(Dish cells)
  {
    if(cells.size() == 0)
      return PVector.sub(target.loc,a.loc);
 
    if(a.dist(target) > a.effectiveSensoryRange() * 2 || target.w <= 0)//you can track a single target to 2 times your sensory range
      target = a;
    if(a.dist(predator) > a.effectiveSensoryRange() || predator.w <= 0)
      predator = a;
 
    for(int k = 0 ; k < cells.size(); k++)
    {
      Cell c = cells.get(k);//(int)random(cells.size()-1));
 
      if(targetQuality(c) > targetQuality(target) && goodToEat(c))
        target = c;//set it as the new target
      if(c instanceof Animal)//then check for predators
      {
        Animal threat = (Animal) c;
        if(threat.myBrain.targetQuality(a) > predator.myBrain.targetQuality(a) && threat.myBrain.goodToEat(a))// && a.carn > predator.carn)
          predator = threat;//set it as the new predator
      }
    }
 
    if(predator != a && predator.dist(target) < minDist)
      return PVector.mult(PVector.sub(a.loc,predator.loc),100);//run from the predator
    else
      return PVector.sub(target.loc,a.loc);//chase the prey
  }
 
  public float targetQuality(Cell c)//returns a value aproximating the benefit of going after c
  {
    if(!goodToEat(c))
      return 0;
     
    if(c instanceof Animal)
      return c.w * (a.amtGained(c) - ((Animal)c).amtEaten(a)) / (100+a.dist(c)-sqrt(c.w));
    else//if its a plant
    return a.amtGained(c) / (100+a.dist(c)-sqrt(c.w));
  }
 
  public boolean goodToEat(Cell c)
  {
    return c != a && !(c instanceof Animal && ((Animal)c).myBrain.marker == marker);
  }
 
  public String toString()
  {
    return "";
  }
}
