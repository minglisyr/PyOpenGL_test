import pygame as pg
from OpenGL.GL import *
import numpy as np
import ctypes
from OpenGL.GL.shaders import compileProgram, compileShader

class App:

    def __init__(self):
        
        #initialize python
        pg.init()
        pg.display.set_mode((800, 600), pg.DOUBLEBUF | pg.OPENGL)
        self.clock = pg.time.Clock()

        #initialize OpenGL settings
        glClearColor(0.1, 0.2, 0.2, 1.0)
        self.shader = self.createShader('vertex.glsl', 'fragment.glsl')
        glUseProgram(self.shader)
        self.triangle = Triangle()
        self.mainLoop()

    def createShader(self, vertex_shader_source, fragment_shader_source):

        with open(vertex_shader_source, 'r') as f:
            vertex_src = f.readlines()

        with open(fragment_shader_source, 'r') as f:
            fragment_src = f.readlines()

        shader = compileProgram(
            compileShader(''.join(vertex_src), GL_VERTEX_SHADER),
            compileShader(''.join(fragment_src), GL_FRAGMENT_SHADER)
        )

        return shader
    
    def mainLoop(self):
        running = True
        while (running):
            #check events
            for event in pg.event.get():
                if event.type == pg.QUIT:
                    running = False

            #update screen
            glClear(GL_COLOR_BUFFER_BIT)

            glUseProgram(self.shader)
            glBindVertexArray(self.triangle.vao)
            glDrawArrays(GL_TRIANGLES, 0, self.triangle.vertex_count)

            pg.display.flip()

            #timing
            self.clock.tick(60)

        self.quit()

    def quit(self):
        glDeleteProgram(self.shader)
        self.triangle.destroy()
        print("Application closed successfully.")
        # Exit the application
        pg.quit()
        exit()

class Triangle:

    def __init__(self):
        
        # x,y,z,r,g,b
        self.vertices = np.array([
            -0.5, -0.5, 0.0, 1.0, 0.0, 0.0,
             0.5, -0.5, 0.0, 0.0, 1.0, 0.0,
             0.0,  0.5, 0.0, 0.0, 0.0, 1.0
        ], dtype=np.float32)

        self.vertex_count = 3

        self.vao = glGenVertexArrays(1)
        glBindVertexArray(self.vao)
        self.vbo = glGenBuffers(1)
        glBindBuffer(GL_ARRAY_BUFFER, self.vbo)
        glBufferData(GL_ARRAY_BUFFER, self.vertices.nbytes, self.vertices, GL_STATIC_DRAW)
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 24, ctypes.c_void_p(0))
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 24, ctypes.c_void_p(12))

    def destroy(self):

        glDeleteVertexArrays(1, [self.vao])
        glDeleteBuffers(1, [self.vbo])

if __name__ == "__main__":
    myApp = App()
