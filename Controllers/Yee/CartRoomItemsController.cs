using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using HotelFuen31.APIs.Models;

namespace HotelFuen31.APIs.Controllers.Yee
{
    public class CartGetDto
    {
        public string Phone { get; set; }
    }

    public class CartItemVm
    {
        public int Id { get; set; }
        public string Picture { get; set; }
        public string Name { get; set; }
        public int Price { get; set; }
        public int Count { get; set; }
        public bool Selected { get; set; }
        public string Phone { get; set; }
        //"id":"4023114",
        //"skuId":"300450920",
        //"name":"KJE金属色系轻量电动车骑行盔男女通用",
        //"attrsText":"颜色:玫瑰金L ",
        //"specs":[],
        //"picture":"https://yanxuan-item.nosdn.127.net/8f3a3b7dc6ca874f934b15af31417f61.png",
        //"price":"120.00",
        //"nowPrice":"120.00",
        //"nowOriginalPrice":"120.00",
        //"selected":true,
        //"stock":5458,
        //"count":433,
        //"isEffective":true,
        //"discount":null,
        //"isCollect":false,
        //"postFee":0,
    }


    [Route("api/[controller]")]
    [ApiController]
    public class CartController : ControllerBase
    {
        private readonly AppDbContext _context;

        public CartController(AppDbContext context)
        {
            _context = context;
        }

        // POST: api/Cart/list
        [HttpPost]
        [Route("list")]
        public ActionResult<IEnumerable<CartItemVm>> PostCartList([FromBody] CartGetDto dto)
        {
            if (string.IsNullOrEmpty(dto.Phone))
            {
                return null;
            }

            var vms = _context.CartRoomItems
                .AsNoTracking()
                .Include(cri => cri.Room)
                .Join(
                    _context.RoomTypes,
                    cri => cri.Room.RoomTypeId,
                    rt => rt.RoomTypeId,
                    (cri, rt) => new CartItemVm
                    {
                        Id = cri.Id,
                        Picture = rt.ImageUrl,
                        Name = rt.TypeName,
                        Price = rt.WeekdayPrice,
                        Count = 1,
                        Selected = false,
                        Phone = cri.Phone,
                    })
                .Where(vm => vm.Phone == dto.Phone)
                .ToList();

            vms.ForEach(vm =>
            {
                var pic = string.IsNullOrEmpty(vm.Picture) ? "noImage.png" : vm.Picture;
                vm.Picture = $"{HttpContext.Request.Scheme}://{HttpContext.Request.Host}{Url.Content($"~/StaticFiles/Chen/{pic}")}";
            });


            return vms;
        }

        // GET: api/Cart/5
        [HttpGet("{criId}")]
        public async Task<ActionResult<CartRoomItem>> GetCartRoomItem(int criId)
        {
            var cartRoomItem = await _context.CartRoomItems.FindAsync(criId);

            if (cartRoomItem == null)
            {
                return NotFound();
            }

            return cartRoomItem;
        }

        // PUT: api/Cart/5
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPut("{criId}")]
        public async Task<IActionResult> PutCartRoomItem(int criId, CartRoomItem cartRoomItem)
        {
            if (criId != cartRoomItem.Id)
            {
                return BadRequest();
            }

            _context.Entry(cartRoomItem).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CartRoomItemExists(criId))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return NoContent();
        }

        // POST: api/Cart
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        [HttpPost]
        public async Task<ActionResult<CartRoomItem>> PostCartRoomItem(CartRoomItem cartRoomItem)
        {
            _context.CartRoomItems.Add(cartRoomItem);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetCartRoomItem", new { id = cartRoomItem.Id }, cartRoomItem);
        }

        // DELETE: api/Cart/5
        [HttpDelete("{criId}")]
        public async Task<IActionResult> DeleteCartRoomItem(int criId)
        {
            var cartRoomItem = await _context.CartRoomItems.FindAsync(criId);
            if (cartRoomItem == null)
            {
                return NotFound();
            }

            _context.CartRoomItems.Remove(cartRoomItem);
            await _context.SaveChangesAsync();

            return NoContent();
        }

        private bool CartRoomItemExists(int criId)
        {
            return _context.CartRoomItems.Any(e => e.Id == criId);
        }
    }
}
