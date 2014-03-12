public class BrainManual extends Brain
{
  public BrainManual(Animal body)
  {
    super(body);
  }
 
  public BrainManual(Animal body, Brain parent)
  {
    this(body);
  }
 
  public PVector move(Dish cells)
  {
    zoom = width / (a.effectiveSensoryRange()*2);
    a.myDish.loc = PVector.mult(a.loc,-1);//places the camera directly above the controlled cell
     
    PVector move = PVector.sub(cursor,a.myDish.loc);
    move.sub(a.loc);
    move.div(10);
    return move;
  }
}
