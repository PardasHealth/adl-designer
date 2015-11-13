package org.openehr.designer.web;


import org.eclipse.egit.github.core.User;
import org.eclipse.egit.github.core.client.GitHubClient;
import org.eclipse.egit.github.core.service.UserService;
import org.openehr.designer.Configuration;
import org.openehr.designer.repository.github.egitext.GetAccessTokenRequest;
import org.openehr.designer.repository.github.egitext.GetAccessTokenResponse;
import org.openehr.designer.repository.github.egitext.GitOauthService;
import org.openehr.designer.user.UserConfigurationService;
import org.openehr.designer.user.UserRepositoriesConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Created by Denko on 10/27/2015.
 */
@RequestMapping(value = "")
@Controller
public class AppController {
    private static final Logger LOG = LoggerFactory.getLogger(AppController.class);

    @Resource
    private GithubRepositoryProvider githubRepositoryProvider;
    @Resource
    private UserConfigurationService userConfigurationService;

    @RequestMapping(method = RequestMethod.GET, value = "/template-editor")
    public String displayTemplateEditor(HttpServletRequest req, HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Expires", "0");
        return "template-editor";
    }


//    @RequestMapping(method = RequestMethod.GET, value = "/RepositoryProvider")
//    public ModelAndView displayTest(HttpServletRequest req, @RequestParam String repo) throws Exception {
//        SessionContext ctx = WebAttributes.getSessionConfiguration(req.getSession());
//        ctx.setGithubRepository(repo);
//
//        // trigger repository init if needed
//        githubRepositoryProvider.getArchetypeRepository(ctx);
//        githubRepositoryProvider.getTemplateRepository(ctx);
//
//        return new ModelAndView("redirect:/template-editor");
//    }
//
//    @RequestMapping(method = RequestMethod.GET, value = "/AddRepository")
//    public ResponseEntity<String> RepoAdder(HttpServletRequest req, @RequestParam String value) throws Exception {
//        SessionContext ctx = WebAttributes.getSessionConfiguration(req.getSession());
//
//        UserRepositoriesConfiguration repositories = userConfigurationService.getRepositories(ctx.getUsername());
//        if (repositories.findByName(value).isPresent()) {
//            return new ResponseEntity<>("Repository already in repository list", HttpStatus.BAD_REQUEST);
//        }
//
//        // tries to initialize the added repository as a way of validation
//        githubRepositoryProvider.getTemplateRepository(ctx, value);
//        GithubArchetypeRepository archetypeRepository = (GithubArchetypeRepository)
//                githubRepositoryProvider.getArchetypeRepository(ctx, value);
//
//        UserRepositoryConfiguration repo = new UserRepositoryConfiguration();
//        repo.setName(value);
//        repo.setFork(archetypeRepository.isFork());
//        userConfigurationService.saveRepository(ctx.getUsername(), repo);
//
//        return new ResponseEntity<>("Repository added successfully!", HttpStatus.OK);
//    }

    @RequestMapping(method = RequestMethod.GET, value = "/authorize")
    public String authorize(HttpServletRequest req, @RequestParam String code) throws Exception {
        SessionContext ctx = new SessionContext();

        if (ctx.getGithubToken() == null) {
            if (code != null) {
                GitOauthService gos = new GitOauthService();
                GetAccessTokenResponse gatr = gos.getAccessToken(new GetAccessTokenRequest(
                        Configuration.get("github.api.auth.client_id"),
                        Configuration.get("github.api.auth.secret"),
                        code
                ));
                ctx.setGithubToken(gatr.getAccessToken());
            }
        }

        GitHubClient github = new GitHubClient();
        github.setOAuth2Token(ctx.getGithubToken());
        UserService userService = new UserService(github);
        User user = userService.getUser();
        ctx.setUsername(user.getLogin());

        UserRepositoriesConfiguration repositories = userConfigurationService.getRepositories(ctx.getUsername());

        String lastRepository = repositories.findByName(repositories.getLastRepository())
                .orElse(repositories.getRepositories().get(0)).getName();
        ctx.setGithubRepository(lastRepository);

        req.getSession().setAttribute(WebAttributes.SESSION_CONTEXT, ctx);

        return "redirect:/";
    }


    @RequestMapping(method = RequestMethod.GET, value = "/logout")
    public String logout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getSession().removeAttribute(WebAttributes.SESSION_CONTEXT);
        req.getSession().invalidate();
        return "redirect:/";
    }


}
