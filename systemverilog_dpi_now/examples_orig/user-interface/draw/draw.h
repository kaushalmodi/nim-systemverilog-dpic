
int draw_init(int width, int height);
void draw_title(int win, const char *label);
void draw_pixel(int win, int x, int y, int n, int minlimit, int maxlimit);
void draw_flush(int win);
void draw_finish(int win);
void draw_clear(int win);
